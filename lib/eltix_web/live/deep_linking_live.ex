defmodule EltixWeb.DeepLinkingLive do
  use EltixWeb, :live_view

  @impl true
  def mount(params, session, socket) do
    {:ok, assign(socket, foo: "hello", claims: session["claims"])}
  end

  @impl true
  def handle_event("foo", %{"text" => text}, socket) do
    {:noreply, assign(socket, foo: text)}
  end
end

