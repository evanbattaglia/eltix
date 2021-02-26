defmodule Eltix.Platform do
  @moduledoc """
  Information about the LMS we have set up this tool for.
  Currently we only support one LMS, manually set up in the config.
  In the future we could support more, for instance by storing platform
  information in a database.
  """

  def iss, do: config()[:iss]
  def public_keys_url, do: config()[:public_keys_url]
  def authentication_redirect_url, do: config()[:authentication_redirect_url]

  @doc """
  Fetches the URL known to host the Platform's trusted public keys, as
  specified in the config.
  """
  def public_keys_raw do
    case HTTPoison.get(public_keys_url()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: code, body: _}} -> {:error, "Failed to fetch platform keys, status #{code}"}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, "Failed to fetch plaform keys, #{reason}"}
    end
  end

  defp config do
    Application.get_env(:eltix, __MODULE__)
  end
end
