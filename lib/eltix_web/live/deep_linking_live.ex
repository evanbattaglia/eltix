defmodule EltixWeb.DeepLinkingLive do
  use EltixWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, foo: "hello")}
  end

  @impl true
  def handle_event("foo", %{"text" => text}, socket) do
    {:noreply, assign(socket, foo: text)}
  end
end

