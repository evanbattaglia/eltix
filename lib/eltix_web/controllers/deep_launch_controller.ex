defmodule EltixWeb.DeepLaunchController do
  use EltixWeb, :controller

  def index(conn, params) do
    Phoenix.LiveView.Controller.live_render(
      conn,
      EltixWeb.DeepLinkingLive,
      session: %{"claims" => conn.assigns.claims}
    )
  end
end
