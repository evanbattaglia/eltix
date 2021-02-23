defmodule Eltix.Nonce do
  @moduledoc """
  Nonce and state combined.
  """

  # Used nonce sentinel, must not be a possible nonce value
  @used_nonce_sentinel "ELTIX-NONCE-USED"

  defstruct [:nonce, :state]

  @spec new_nonce_and_state() :: {String.t(), String.t()}
  def new_nonce_and_state do
    nonce = UUID.uuid1()
    state = UUID.uuid1()
    Eltix.NonceStore.set(nonce, state)
    {nonce, state}
  end

  @spec use_and_validate_nonce_and_state(String.t, String.t) :: :ok | {:error, String.t}
  def use_and_validate_nonce_and_state(nonce_string, state_string) do
    case Eltix.NonceStore.get_and_set(nonce_string, @used_nonce_sentinel) do
      {:ok, @used_nonce_sentinel} -> {:error, "Nonce used already"}
      {:ok, ^state_string} -> :ok
      {:ok, _} -> {:error, "State does not match"}
      {:error, err} -> {:error, "Could not load nonce/state: #{err}"}
    end
  end
end
