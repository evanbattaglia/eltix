defmodule Eltix.NonceStore do
  @moduledoc """
  Store for the nonce and state. This is needed because the app generates a
  nonce and state, sends them to the LMS in the 2nd request of the LTI launch,
  and expects to receive them back. So in the last launch, we must check the
  nonce and state against what we have stored.

  Wrapped around a GenServer so we can be sure of atomicity
  (this process alone is responsible for the table).
  I guess "protected" does that as well.

  TODO: should use redis instead of ETS eventually... But this
  was good to learn ETS & GenServer...
  TODO: need to expire these (set expiry when they are first set)
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, :ets.new(:nonce_store, [:set, :protected])}
  end

  @impl true
  def handle_cast({:set, key, val}, table) do
    :ets.insert(table, {key, val})
    {:noreply, table}
  end

  @impl true
  def handle_call({:get_and_set, key, newval}, _from, table) do
    result = case :ets.lookup(table, key) do
      [] -> {:error, "Key not found"}
      [{_key, oldval}] ->
        :ets.insert(table, {key, newval})
        {:ok, oldval}
    end

    {:reply, result, table}
  end

  def set(key, val) do
    GenServer.cast(__MODULE__, {:set, key, val})
  end

  def get_and_set(key, val) do
    GenServer.call(__MODULE__, {:get_and_set, key, val})
  end
end
