defmodule SammelanaWeb.UserControllerTest do
  use SammelanaWeb.ConnCase

  import Sammelana.AccountsFixtures
  alias Sammelana.Accounts.User

  @create_attrs %{
    name: "some name",
    mobileno: "some mobileno",
    email: "some email",
    bio: "some bio"
  }
  @update_attrs %{
    name: "some updated name",
    mobileno: "some updated mobileno",
    email: "some updated email",
    bio: "some updated bio"
  }
  @invalid_attrs %{name: nil, mobileno: nil, email: nil, bio: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "bio" => "some bio",
               "email" => "some email",
               "mobileno" => "some mobileno",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "get_or_create user" do
    test "returns existing user when email exists", %{conn: conn} do
      user = user_fixture(%{email: "existing@example.com"})

      conn =
        post(conn, ~p"/api/users/get_or_create",
          user: %{email: "existing@example.com", name: "irrelevant"}
        )

      assert json_response(conn, 200)
      assert json_response(conn, 200)["data"]["id"] == user.id
    end

    test "creates user when not exists", %{conn: conn} do
      params = %{email: "newuser@example.com", name: "New User", mobileno: "12345", bio: "hi"}

      conn = post(conn, ~p"/api/users/get_or_create", user: params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")
      assert %{"id" => ^id, "email" => "newuser@example.com"} = json_response(conn, 200)["data"]
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "bio" => "some updated bio",
               "email" => "some updated email",
               "mobileno" => "some updated mobileno",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()

    %{user: user}
  end
end
