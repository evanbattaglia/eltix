defmodule Eltix.JWT do
  @moduledoc """
  Functions to verify JWTs from the platform.
  """

  # Parse and verify a JWT was signed with one of the given signers.
  @spec verify(list, String.t()) :: {:ok, map()} | {:error, String.t()}
  defp verify_with_signers(signers, jwt_string) when is_list(signers) do
    signers
    |> Stream.map(&(Joken.Signer.verify(jwt_string, &1)))
    |> Enum.find(&match?({:ok, _}, &1))
    || {:error, "Cannot verify or parse JWT"}
  end

  @doc """
  Parse and verify a JWT was signed with one of the the keys, given a raw JWKs
  string.
  """
  def verify(jwks_string, jwt_string) when is_binary(jwks_string) do
    with {:ok, signers} <- create_signers_from_jwks(jwks_string) do
      verify_with_signers(signers, jwt_string)
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

  def private_key do
    Application.get_env(:eltix, __MODULE__)[:private_key]
  end

  def public_key_jwk do
    {:RSAPrivateKey, :'two-prime', n, e, _d, _p, _q, _e1, _e2, _c, _other} =
      private_key() |> :public_key.pem_decode |> List.first |> :public_key.pem_entry_decode
    {_jose_kty_stuff, blob} = {:RSAPublicKey, n, e} |> JOSE.JWK.from_key |> JOSE.JWK.to_map
    blob |> Map.merge(%{"alg" => "RS256", "use" => "sig", "kid" => "Eltix JWK"})
  end
end
