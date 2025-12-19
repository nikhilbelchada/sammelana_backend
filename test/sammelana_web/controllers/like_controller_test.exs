defmodule SammelanaWeb.LikeControllerTest do
  use SammelanaWeb.ConnCase

  import Sammelana.ContentFixtures
  import Sammelana.AccountsFixtures


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  describe "create like" do
    setup [:create_user, :create_post]

    test "renders like when data is valid", %{conn: conn, user: user, post: post} do
      create_attrs = %{
        meta: %{},
        user_id: user.id,
        post_id: post.id
      }
      conn = post(conn, ~p"/api/likes", like: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/likes/#{id}")

      assert %{
               "id" => ^id,
               "meta" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/likes", like: %{meta: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete like" do
    setup [:create_user, :create_post, :create_like]

    test "deletes chosen like", %{conn: conn, like: like} do
      conn = delete(conn, ~p"/api/likes/#{like}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/likes/#{like}")
      end
    end
  end

  defp create_like(opts) do
    like = like_fixture(%{
      user_id: opts.user.id,
      post_id: opts.post.id
    })

    %{like: like}
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
end
