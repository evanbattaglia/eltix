defmodule Eltix.JWT do
  @moduledoc """
  Functions to verify JWTs from the platform.
  """

  @doc """
  Parse and verify a JWT was signed with one of the given signers.
  """
  @spec verify(list, String.t()) :: {:ok, map()} | {:error, String.t()}
  def verify(signers, jwt_string) when is_list(signers) do
    signers
    |> Stream.map(&(Joken.Signer.verify(jwt_string, &1)))
    |> Enum.find(&match?({:ok, _}, &1))
    || {:error, "Cannot verify or parse JWT"}
  end

  @doc """
  Parse and verify a JWT was signed with one of the Platform's known trusted
  keys. The keys are retrieved from the endpoint in Eltix.Platform.
  """
  def verify(jwt_string) do
    with {:ok, jwks_string} <- Eltix.Platform.public_keys_raw,
         {:ok, signers} <- create_signers_from_jwks(jwks_string) do
      verify(signers, jwt_string)
    end
  end

  # Create a list of Joken signers from a JWKs JSON string (with object value
  # "keys")
  # Returns {:ok, list} or {:error, reason_string}
  defp create_signers_from_jwks(jwk_set_string) do
    with {:ok, obj} <- Jason.decode(jwk_set_string),
         %{"keys" => keys} <- obj,
         [_|_] <- keys do
      {:ok, Enum.map(keys, &Joken.Signer.create("RS256", &1))}
    else
      _ -> {:error, "Cannot load keys"}
    end
  end
end


