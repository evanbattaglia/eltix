defmodule EltixWeb.ConfigController do
  @moduledoc """
  Provides the LTI 1.3 configuration that can be used to add the Developer Key
  in Canvas.
  """

  use EltixWeb, :controller

  def index(conn, _params) do
    render(conn, :index, %{app_root_url: app_root_url(conn), public_jwk: Eltix.JWT.public_key_jwk})
  end

  defp app_root_url(conn) do
    URI.to_string %URI{host: conn.host, scheme: Atom.to_string(conn.scheme), port: conn.port}
  end
end
