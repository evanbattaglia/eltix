defmodule EltixWeb.LoginController do
  use EltixWeb, :controller

  plug :verify_iss

  def verify_iss(conn, _opts) do
    iss = conn.params["iss"]
    if iss == Eltix.Platform.iss() do
      conn
    else
      conn |> render_error(401, "Invalid iss: #{iss}") |> halt
    end
  end

  def login_request(conn, params) do
    # TODO: verify iss matches (or in launch?)
    render(conn, "login_request.html",
      uri: Eltix.Platform.authentication_redirect_url,
      params: login_params(params))
  end

# Canvas sends:
# iss: https://canvas.instructure.com
# login_hint: 535fa085f22b4655f48cd5a36a9215f64c062838
# client_id: 10000000000006
# target_link_uri: http://web.lti-13-test-tool.docker/launch?placement=account_navigation
# lti_message_hint: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2ZXJpZmllciI6ImI0ZjA1OWJmYjA4NzY0MTJjZTQ3MDRkN2M4YWRhYjJjMTQ1ZjRiYTNmMWNjNjZiYjc2NTE3OWM3MTg4NGE4OTI4MDM2NzMzMTA5ZmE2NzQxNDUzN2ZjZGQzYjIxYTZhNWI5MTkwYWI0MGQ4MjE5ODBjODEwNGY5OGRmMTgzYjAzIiwiY2FudmFzX2RvbWFpbiI6IndlYi5jYW52YXMtbG1zMi5kb2NrZXIiLCJjb250ZXh0X3R5cGUiOiJBY2NvdW50IiwiY29udGV4dF9pZCI6MTAwMDAwMDAwMDAwMDIsImV4cCI6MTYxNDA2MjE0MX0.8Gy5wNkCE9Vzq5BgYaplLthJPZFzuxA2cgiph2jG4qA
# canvas_region: not_configured
  #
  # TODO put in config

  defp login_params(params) do
    {nonce, state} = Eltix.Nonce.new_nonce_and_state

    [
      scope: "openid",
      response_mode: "form_post",
      response_type: "id_token",
      prompt: "none", # No idea what this is

      client_id: params["client_id"],
      lti_message_hint: params["lti_message_hint"],
      login_hint: params["login_hint"], # TODO learn what this is -- why are there two hints

      state: state,
      nonce: nonce,

      redirect_uri: params["target_link_uri"], # TODO build this from request URL & routes
    ]
  end
end

