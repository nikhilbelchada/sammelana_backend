defmodule SammelanaWeb.PostControllerTest do
  use SammelanaWeb.ConnCase

  import Sammelana.ContentFixtures
  import Sammelana.AccountsFixtures
  alias Sammelana.Content.Post

  @create_attrs %{
    description: "some description",
    title: "some title",
    images: ["option1", "option2"]
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    images: ["option1"]
  }
  @invalid_attrs %{description: nil, title: nil, images: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/api/posts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    setup [:create_user]

    test "renders post when data is valid", %{conn: conn, user: user} do
      create_attrs = Map.put(@create_attrs, :user_id, user.id)

      conn = post(conn, ~p"/api/posts", post: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/posts/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "images" => ["option1", "option2"],
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/posts", post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:create_user, :create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post, user: user} do
      update_attrs = Map.put(@update_attrs, :user_id, user.id)
      conn = put(conn, ~p"/api/posts/#{post}", post: update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/posts/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "images" => ["option1"],
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, ~p"/api/posts/#{post}", post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_user, :create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, ~p"/api/posts/#{post}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/posts/#{post}")
      end
    end
  end

  defp create_post(opts) do
    post =
      post_fixture(%{
        user_id: opts.user.id,
        title: "post-#{System.unique_integer([:positive])}"
      })

    %{post: post}
  end

  defp create_user(_) do
    user = user_fixture(%{name: "user-#{System.unique_integer([:positive])}"})
    %{user: user}
  end
end
