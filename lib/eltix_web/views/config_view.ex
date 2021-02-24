defmodule EltixWeb.ConfigView do
  use EltixWeb, :view
  alias EltixWeb.Endpoint

  @placements ~w(
    account_navigation
    course_navigation
    global_navigation
  )

  def render("index.json", %{app_root_url: app_root_url}) do
    %{
      title: "Eltix",
      scopes: [],
      description: "Eltix = Elixir + LTI + Phoenix",
      oidc_initiation_url: app_root_url <> Routes.login_path(Endpoint, :login),
      target_link_uri: app_root_url <> Routes.launch_path(Endpoint, :launch),
      public_jwk: public_jwk(),
      extensions: [
        %{
          platform: "canvas.instructure.com",
          domain: app_root_url,
          tool_id: "Eltix",
          settings: %{
            text: "Eltix",
            icon_url: "#{app_root_url}/images/eltix.png",
            placements: placements(app_root_url),
          }
        }
      ]
    }
  end

  defp placements(app_root_url) do
    launch_url = app_root_url <> Routes.launch_path(Endpoint, :launch)

    Enum.map(@placements, fn(placement) ->
      %{
        enabled: true,
        placement: placement,
        message_type: "LtiResourceLinkRequest",
        target_link_uri: "#{launch_url}?placement=#{URI.encode placement}",
      }
    end)
  end


  # TODO: this is a stub key (used in my LTI 1.3 test tool), since we don't use
  # deep linking yet. Canvas requires a public key
  defp public_jwk do
    %{
      e: "AQAB",
      n: "sFaCP0QtWb2G611txzJqUYo_I37TMYP_zMlsPslvSAB0SFaX6el2LdTUATqIfrVpXKgK8gKtaj1Y-OxPLcXVjzxANatoXZxzzSlKi3IPcnfknhIOjNgIBGEWNuHux0NFR8lMFLijxa4u57JPD6c-0_wwoe9Y3I9yveKkzapaqDSFYf1GrmIfjf0GFBkHqyE86jlR83FdvDRbAxNs1d57ijJmyhT7Tt-gkwYUKyfNiB9aT7g9ZGs7zs6ufkauAd6Ks7BYlC9iLYKg2h0SZ1Du6tYr195KcP82HHSWsPrzvlsigVc9jNTIrPlB_eL-5JSRiRi8njTn7GrgP9-tt5zGWQ",
      alg: "RS256",
      kid: "q9Q1sUDmKjdB4ILtkkkRUWGCDxWEZYCW12soIormadw",
      kty: "RSA",
      use: "sig",
    }
  end

end
