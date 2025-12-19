defmodule Sammelana.ContentTest do
  use Sammelana.DataCase

  import Sammelana.ContentFixtures
  import Sammelana.AccountsFixtures

  alias Sammelana.Content
  alias Sammelana.Content.Post

  describe "posts" do
    setup [:create_user]

    @invalid_attrs %{description: nil, title: nil, images: nil}

    test "list_posts/0 returns all posts", %{user: user} do
      post = post_fixture(%{user_id: user.id})
      assert Content.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id", %{user: user} do
      post = post_fixture(%{user_id: user.id})
      assert Content.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post", %{user: user} do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        images: ["option1", "option2"],
        user_id: user.id
      }

      assert {:ok, %Post{} = post} = Content.create_post(valid_attrs)
      assert post.description == "some description"
      assert post.title == "some title"
      assert post.images == ["option1", "option2"]
      assert post.user_id == user.id
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post", %{user: user} do
      post = post_fixture(%{user_id: user.id})

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        images: ["option1"]
      }

      assert {:ok, %Post{} = post} = Content.update_post(post, update_attrs)
      assert post.description == "some updated description"
      assert post.title == "some updated title"
      assert post.images == ["option1"]
    end

    test "update_post/2 with invalid data returns error changeset", %{user: user} do
      post = post_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Content.update_post(post, @invalid_attrs)
      assert post == Content.get_post!(post.id)
    end

    test "delete_post/1 deletes the post", %{user: user} do
      post = post_fixture(%{user_id: user.id})
      assert {:ok, %Post{}} = Content.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Content.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{user: user} do
      post = post_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Content.change_post(post)
    end
  end

  describe "comments" do
    setup [:create_user, :create_post]

    alias Sammelana.Content.Comment

    import Sammelana.ContentFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      assert Content.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      assert Content.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment", %{user: user, post: post} do
      valid_attrs = %{body: "some body", user_id: user.id, post_id: post.id}

      assert {:ok, %Comment{} = comment} = Content.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Content.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      assert {:error, %Ecto.Changeset{}} = Content.update_comment(comment, @invalid_attrs)
      assert comment == Content.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      assert {:ok, %Comment{}} = Content.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Content.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", %{user: user, post: post} do
      comment = comment_fixture(%{user_id: user.id, post_id: post.id})
      assert %Ecto.Changeset{} = Content.change_comment(comment)
    end
  end

  describe "likes" do
    setup [:create_user, :create_post]

    alias Sammelana.Content.Like

    import Sammelana.ContentFixtures

    @invalid_attrs %{meta: nil}

    test "list_likes/0 returns all likes", %{user: user, post: post} do
      like = like_fixture(%{user_id: user.id, post_id: post.id})
      assert Content.list_likes() == [like]
    end

    test "get_like!/1 returns the like with given id", %{user: user, post: post} do
      like = like_fixture(%{user_id: user.id, post_id: post.id})
      assert Content.get_like!(like.id) == like
    end

    test "create_like/1 with valid data creates a like", %{user: user, post: post} do
      valid_attrs = %{meta: %{}, user_id: user.id, post_id: post.id}

      assert {:ok, %Like{} = like} = Content.create_like(valid_attrs)
      assert like.meta == %{}
    end

    test "create_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_like(@invalid_attrs)
    end

    test "delete_like/1 deletes the like", %{user: user, post: post} do
      like = like_fixture(%{user_id: user.id, post_id: post.id})
      assert {:ok, %Like{}} = Content.delete_like(like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_like!(like.id) end
    end

    test "change_like/1 returns a like changeset", %{user: user, post: post} do
      like = like_fixture(%{user_id: user.id, post_id: post.id})
      assert %Ecto.Changeset{} = Content.change_like(like)
    end
  end

  defp create_user(_) do
    user = user_fixture(%{name: "user-#{System.unique_integer([:positive])}"})
    %{user: user}
  end

  defp create_post(opts) do
    post =
      post_fixture(%{
        user_id: opts.user.id
      })

    %{post: post}
  end
end
