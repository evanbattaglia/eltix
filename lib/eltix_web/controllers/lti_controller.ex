defmodule EltixWeb.LtiController do
  use EltixWeb, :controller

  def login_request(conn, params) do
    render(conn, "login_request.html", uri: login_lms_uri, params: login_params(params))
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
  defp login_lms_uri do
    "http://web.canvas-lms2.docker/api/lti/authorize_redirect"
  end

  defp login_params(params) do
    [
      scope: "openid",
      response_mode: "form_post",
      response_type: "id_token",
      prompt: "none", # No idea what this is

      client_id: params["client_id"],
      lti_message_hint: params["lti_message_hint"],
      login_hint: params["login_hint"], # TODO learn what this is

      state: "something_secret_TODO_figureout", # TODO
      nonce: "something_secret2", # TODO

      redirect_uri: params["target_link_uri"], # TODO build this from request URL
    ]
  end

  def launch(conn, %{"id_token" => id_token}) do
    render(conn, "launch.html", id_token: id_token)
  end
;
  def launch(conn, %{"error" => err, "error_description" => err_desc}) do
    # Could check state here is wanted to...
    render_error(conn, 400, "Got error from LMS: #{err}: #{err_desc}")
  end

  def launch(conn, _params), do: render_error(conn, 401, "Missing id_token")

  # TODO: decode JWT, check signature...
end

