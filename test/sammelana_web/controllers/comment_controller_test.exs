defmodule SammelanaWeb.CommentControllerTest do
  use SammelanaWeb.ConnCase

  import Sammelana.ContentFixtures
  import Sammelana.AccountsFixtures

  @invalid_attrs %{body: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create comment" do
    setup [:create_user, :create_post]

    test "renders comment when data is valid", %{conn: conn, user: user, post: post} do
      create_attrs =
        %{
          body: "some body",
          user_id: user.id,
          post_id: post.id
        }

      conn = post(conn, ~p"/api/comments", comment: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/comments/#{id}")

      assert %{
               "id" => ^id,
               "body" => "some body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/comments", comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    setup [:create_user, :create_post, :create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, ~p"/api/comments/#{comment}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/comments/#{comment}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture(%{name: "user-#{System.unique_integer([:positive])}"})
    %{user: user}
  end

  defp create_post(opts) do
    post =
      post_fixture(%{
        user_id: opts.user.id,
        title: "post-#{System.unique_integer([:positive])}"
      })

    %{post: post}
  end

  defp create_comment(opts) do
    comment =
      comment_fixture(%{
        user_id: opts.user.id,
        post_id: opts.post.id
      })

    %{comment: comment}
  end
end
