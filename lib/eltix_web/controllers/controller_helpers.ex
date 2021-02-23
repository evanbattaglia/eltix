defmodule EltixWeb.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller

  @doc """
  Render error for integer code and string msg
  """
  def render_error(conn, code, msg) do
    conn
    |> put_status(code)
    |> put_view(EltixWeb.ErrorView)
    |> render(:"#{code}", message: msg)
  end
end