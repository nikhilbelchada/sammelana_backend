defmodule SammelanaWeb.PageController do
  use SammelanaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
