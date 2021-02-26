defmodule EltixWeb.ConfigView do
  use EltixWeb, :view
  alias EltixWeb.Endpoint

  @basic_placements ~w(
    account_navigation
    course_navigation
    global_navigation
  )

  @deep_linking_placements ~w(
    editor_button
  )

  def render("index.json", %{app_root_url: app_root_url, public_jwk: public_jwk}) do
    %{
      title: "Eltix",
      scopes: [],
      description: "Eltix = Elixir + LTI + Phoenix",
      oidc_initiation_url: app_root_url <> Routes.login_path(Endpoint, :login),
      target_link_uri: app_root_url <> Routes.launch_path(Endpoint, :launch),
      public_jwk: public_jwk,
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
    deep_launch_url = app_root_url <> Routes.deep_linking_path(Endpoint, :index)

    Enum.map(@basic_placements, &placement(&1, launch_url, "LtiResourceLinkRequest")) ++
    Enum.map(@deep_linking_placements, &placement(&1, deep_launch_url, "LtiDeepLinkingRequest"))
  end

  defp placement(placement_name, launch_url, message_type), do: %{
    enabled: true,
    placement: placement_name,
    message_type: message_type,
    target_link_uri: "#{launch_url}?placement=#{URI.encode placement_name}",
  }
end
