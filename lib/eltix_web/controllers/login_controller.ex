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

  def login(conn, params) do
    conn
    |> put_layout("empty.html")
    |> render("login_request.html",
      uri: Eltix.Platform.authentication_redirect_url,
      params: login_params(conn, params))
  end

  defp login_params(conn, params) do
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

      redirect_uri: redirect_uri(conn, params),
    ]
  end

  defp redirect_uri(conn, params) do
    URI.to_string %URI{
      host: conn.host,
      scheme: Atom.to_string(conn.scheme),
      port: conn.port,
      path: Routes.launch_path(EltixWeb.Endpoint, :launch),
      query: extract_query_string(params["target_link_uri"]),
    }
  end

  defp extract_query_string(nil), do: nil
  defp extract_query_string(uri), do: URI.parse(uri).query
end

