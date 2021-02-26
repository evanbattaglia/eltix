defmodule EltixWeb.Router do
  use EltixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EltixWeb.LayoutView, :root}
    # plug :put_secure_browser_headers # TODO: this adds X-Frame-Options: sameorigin which breaks LTI, but may also provide other useful stuff?
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EltixWeb do
    pipe_through :api

    get "/", ConfigController, :index
  end

  scope "/", EltixWeb do
    pipe_through :browser

    post "/login", LoginController, :login
    post "/launch", LaunchController, :launch

    scope "/" do
      pipe_through [DeepLinkingLiveAuthPlug]

      # Need both post & get. Post is for the LTI launch, get is for the
      # subsequent get requests (socket request?)
      live "/deep_launch", DeepLinkingLive, :index
      post "/deep_launch", DeepLaunchController, :index
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: EltixWeb.Telemetry
    end
  end
end
