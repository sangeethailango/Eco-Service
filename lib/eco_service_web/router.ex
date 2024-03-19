defmodule EcoServiceWeb.Router do
  use EcoServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EcoServiceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EcoServiceWeb do
    pipe_through :browser

    live "/", EcoServiceLive.Dashboard
    live "/communities", EcoServiceLive.CommunityList, :index
    live "/communities/:id/edit", EcoServiceLive.CommunityList, :edit
    live "/communities/:id/community_details", EcoServiceLive.CommunityDetails, :community_details
    live "/communities/:id/add_waste", EcoServiceLive.CommunityDetails, :add_waste
  end

  # Other scopes may use custom stacks.
  scope "/api", EcoServiceWeb do
    pipe_through :api

    get "/list_of_communities", PageController, :get_all_communities
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:eco_service, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EcoServiceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
