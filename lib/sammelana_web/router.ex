defmodule SammelanaWeb.Router do
  use SammelanaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SammelanaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug SammelanaWeb.Plugs.GoogleAuth
  end

  scope "/", SammelanaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", SammelanaWeb do
    pipe_through [:api]

    get "/hello", HelloController, :index
    resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, only: [:create, :update, :delete, :show, :index]
    resources "/comments", CommentController, only: [:create, :delete, :show]
    resources "/likes", LikeController, only: [:create, :delete, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SammelanaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sammelana, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SammelanaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
