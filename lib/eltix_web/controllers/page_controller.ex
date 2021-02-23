defmodule EltixWeb.PageController do
  use EltixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
