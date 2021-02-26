defmodule DeepLinkingLiveAuthPlug do
  import Plug.Conn
  import EltixWeb.ControllerHelpers

  def call(conn, _opts) do
    case conn.params do
      %{"error" => err, "error_description" => err_desc} ->
        render_error(conn, 400, "Got error from LMS: #{err}: #{err_desc}")
      _ -> verify_jwt_and_nonce(conn)
    end
  end

  def verify_jwt_and_nonce(conn) do
    case conn.params do
      %{"id_token" => id_token, "state" => state} ->
        with {:ok, jwks_string} <- Eltix.Platform.public_keys_raw,
             {:ok, jwt} <- Eltix.JWT.verify(jwks_string, id_token),
             :ok <- validate_nonce(jwt, state) do
          conn |> assign(:claims, jwt)
        else
          {:error, code, message} -> render_error(conn, code, message)
          {:error, message} -> render_error(conn, 401, message)
        end
      _ ->
        render_error(conn, 401, "Missing id_token and/or state")
    end
  end

  @spec validate_nonce(Map.t(), String.t()) :: :ok | {:error, integer(), Map.t()}
  defp validate_nonce(jwt, state) do
    case jwt["nonce"] do
      nil -> {:error, 401, "Nonce not found in JWT"}
      nonce -> case Eltix.Nonce.use_and_validate_nonce_and_state(nonce, state) do
        {:error, err} -> {:error, 401, "Error validating nonce/state: #{err}"}
        :ok -> :ok
      end
    end
  end

  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    with {:ok, jwks_string} <- Eltix.Platform.public_keys_raw,
         {:ok, jwt} <- Eltix.JWT.verify(jwks_string, conn.params["id_token"]) do
      conn
    else
      _ ->
        conn
        |> send_resp(404, "Hello World!\n")
        |> halt()
    end
  end
end
