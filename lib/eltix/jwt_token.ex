defmodule Eltix.JwtToken do
  @moduledoc """
  Used in Eltix.JWT in conjuntion with Joken
  """

  use Joken.Config

  @impl true
  def token_config do
    default_claims(skip: [:iss, :aud])
  end
end
