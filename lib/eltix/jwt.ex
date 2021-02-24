defmodule Eltix.JWT do
  @spec verify(list, String.t()) :: {:ok, map()} | {:error, String.t()}
  def verify(signers, jwt_string) when is_list(signers) do
    signers
    |> Stream.map(&(Joken.Signer.verify(jwt_string, &1)))
    |> Enum.find(&match?({:ok, _}, &1))
    || {:error, "Cannot verify or parse JWT"}
  end

  @spec verify(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
  def verify(jwk_set_string, jwt_string) do
    with {:ok, signers} <- create_signers_from_jwks(jwk_set_string) do
      verify(signers, jwt_string)
    end
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

  @canvas_jwk_string ~s({"keys":[{"kty":"RSA","e":"AQAB","n":"uX1MpfEMQCBUMcj0sBYI-iFaG5Nodp3C6OlN8uY60fa5zSBd83-iIL3n_qzZ8VCluuTLfB7rrV_tiX727XIEqQ","kid":"2018-05-18T22:33:20Z"},{"kty":"RSA","e":"AQAB","n":"uX1MpfEMQCBUMcj0sBYI-iFaG5Nodp3C6OlN8uY60fa5zSBd83-iIL3n_qzZ8VCluuTLfB7rrV_tiX727XIEqQ","kid":"2018-06-18T22:33:20Z"},{"kty":"RSA","e":"AQAB","n":"uX1MpfEMQCBUMcj0sBYI-iFaG5Nodp3C6OlN8uY60fa5zSBd83-iIL3n_qzZ8VCluuTLfB7rrV_tiX727XIEqQ","kid":"2018-07-18T22:33:20Z"}]})

  def verify(jwt_string) do
    verify(@canvas_jwk_string, jwt_string)
  end
end


