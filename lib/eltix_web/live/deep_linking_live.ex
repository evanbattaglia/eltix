defmodule EltixWeb.DeepLinkingLive do
  use EltixWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, response_id_token: "", claims: session["claims"])}
  end

  @impl true
  def handle_event("submit", %{"msg" => msg}, socket) do
    resp_jwt = Eltix.DeepLinking.build_response_jwt(socket.assigns.claims, msg)
    {:noreply, assign(socket, response_id_token: Jason.encode!(resp_jwt))}
  end

  # Send to deep_linking_response?modal=true with signed JWT:
end

