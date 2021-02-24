defmodule EltixWeb.ConfigController do
  use EltixWeb, :controller

  def index(conn, _params) do
    render(conn, :index, %{app_root_url: app_root_url(conn)})
  end

  defp app_root_url(conn) do
    URI.to_string %URI{host: conn.host, scheme: Atom.to_string(conn.scheme), port: conn.port}
  end
end
