defmodule SammelanaWeb.CommentController do
  use SammelanaWeb, :controller

  alias Sammelana.Content
  alias Sammelana.Content.Comment

  action_fallback SammelanaWeb.FallbackController

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Content.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/comments/#{comment}")
      |> render(:show, comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Content.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def delete(conn, %{"id" => id}) do
    comment = Content.get_comment!(id)

    with {:ok, %Comment{}} <- Content.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
