defmodule EltixWeb.DeepLinkingLive do
  use EltixWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket,
      response_id_token: "",
      deep_link_return_url: Eltix.DeepLinking.deep_link_return_url(session["claims"]),
      claims: session["claims"]
    )}
  end

  @impl true
  def handle_event("submit", %{"msg" => msg}, socket) do
    resp_claims = Eltix.DeepLinking.build_response_claims(socket.assigns.claims, msg)
    {:ok, resp_id_token, _} = Eltix.JWT.build(resp_claims)
    {:noreply, assign(socket, response_id_token: resp_id_token)}
  end

  # Send to deep_linking_response?modal=true with signed JWT:
end

