defmodule EltixWeb.LaunchController do
  @moduledoc """
  Perform LTI launch. The last step in the 3-request LTI launch process.

  For authorization, we check that:
  1) The id_token JWT is signed with the LMS's known key. This ensures that the
     request really came from the LMS.
  2) The nonce and state match up with a valid nonce and state that we
     generated. This ensures the original launch request came thru us.
  3) The nonce has not already been used. This prevents someone from
     intercepting the launch and reusing the same id_token to launch again.

  After this we may display our app.
  """

  use EltixWeb, :controller

  plug DeepLinkingLiveAuthPlug

  def launch(conn, _params) do
    render(conn, "launch.html", query_params: conn.query_params)
  end
end
