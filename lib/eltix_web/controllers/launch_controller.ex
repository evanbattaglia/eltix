defmodule EltixWeb.LaunchController do
  use EltixWeb, :controller

  # Alternate way, maybe worse (more code):
  # import Eltix.ResultMonad, only: :nil_to_error

  # plug :handle_error
  # plug :extract_jwt
  # plug :verify_nonce

  # def handle_error(conn, _opts) do
  #   case conn.params do
  #     %{"error" => err, "error_decription" => desc} -> conn |> render_error(400, "Got error from LMS: #{err}: #{desc}") |> halt()
  #     _ -> conn
  #   end
  # end
  #
  # def extract_jwt(conn, _opts) do
  #   with {:ok, id_token} <- conn.params["id_token"] |> nil_to_error("Missing id_token"),
  #        {:ok, jwt} <- Eltix.JWT.verify(id_token) do
  #     conn |> assigns(:jwt, jwt)
  #   else
  #     {:error, msg} -> render_error(conn, 401, msg) |> halt()
  #   end
  # end

  # def verify_nonce(conn, _opts) do
  #   with {:ok, state} <- conn.params["state"] |> nil_to_error("Missing state"),
  #        {:ok, nonce} <- conn.assigns.jwt["nonce"] |> nil_to_error("Missing nonce in JWT")
  #        :ok <- Eltix.Nonce.use_and_validate_nonce_and_state(nonce, state) do
  #     conn
  #   else
  #     {:error, err} -> render_error(conn, 401, "Error validating nonce/state: #{err}"}
  #   end
  # end


  def launch(conn, %{"error" => err, "error_description" => err_desc}) do
    render_error(conn, 400, "Got error from LMS: #{err}: #{err_desc}")
  end

  def launch(conn, %{"id_token" => id_token, "state" => state}) do
    with {:ok, jwt} <- Eltix.JWT.verify(id_token),
         :ok <- validate_nonce(jwt, state) do
      render(conn, "launch.html", claims: jwt, query_params: conn.query_params)
    else
      {:error, code, message} -> render_error(conn, code, message)
      {:error, message} -> render_error(conn, 401, message)
    end
  end

  def launch(conn, _params), do: render_error(conn, 401, "Missing id_token and/or state")

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
end
