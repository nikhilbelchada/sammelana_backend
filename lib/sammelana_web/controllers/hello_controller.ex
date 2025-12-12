defmodule SammelanaWeb.HelloController do
  use SammelanaWeb, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]

    json(conn, %{
      message: "Hello, authenticated user!",
      user: user
    })
  end
end
