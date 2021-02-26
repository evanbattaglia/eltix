defmodule EltixWeb.LaunchController do
  @moduledoc """
  Perform LTI launch. The last step in the 3-request LTI launch process.

  For authorization, we check that:
  1) The id_token JWT is signed with the LMS's known key. This ensures that the
     request really came from the LMS.
  2) The nonce and state match up with a valid nonce and state that we
     generated. This ensures the original launch request came thru us.
  3) The nonce has not already been used. This prevents someone from
     intercepting the launch and reusing the same id_token to launch again.

  After this we may display our app.
  """

  use EltixWeb, :controller

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
