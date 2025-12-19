defmodule SammelanaWeb.LikeController do
  use SammelanaWeb, :controller

  alias Sammelana.Content
  alias Sammelana.Content.Like

  action_fallback SammelanaWeb.FallbackController

  def create(conn, %{"like" => like_params}) do
    with {:ok, %Like{} = like} <- Content.create_like(like_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/likes/#{like}")
      |> render(:show, like: like)
    end
  end

  def show(conn, %{"id" => id}) do
    like = Content.get_like!(id)
    render(conn, :show, like: like)
  end

  def delete(conn, %{"id" => id}) do
    like = Content.get_like!(id)

    with {:ok, %Like{}} <- Content.delete_like(like) do
      send_resp(conn, :no_content, "")
    end
  end
end
