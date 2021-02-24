defmodule Eltix.JWT do
  @spec verify(list, String.t()) :: {:ok, map()} | {:error, String.t()}
  def verify(signers, jwt_string) when is_list(signers) do
    signers
    |> Stream.map(&(Joken.Signer.verify(jwt_string, &1)))
    |> Enum.find(&match?({:ok, _}, &1))
    || {:error, "Cannot verify or parse JWT"}
  end

  @doc """
  Create a list of Joken signers from a JWKs JSON string (with object value
  "keys")

  Returns {:ok, list} or {:error, reason_string}
  """
  def create_signers_from_jwks(jwk_set_string) do
    with {:ok, obj} <- Jason.decode(jwk_set_string),
         %{"keys" => keys} <- obj,
         [_|_] <- keys do
      {:ok, Enum.map(keys, &Joken.Signer.create("RS256", &1))}
    else
      _ -> {:error, "Cannot load keys"}
    end
  end

  ### 

  def verify(jwt_string) do
    with {:ok, jwks_string} <- Eltix.Platform.public_keys_raw,
         {:ok, signers} <- create_signers_from_jwks(jwks_string) do
      verify(signers, jwt_string)
    end
  end
end


