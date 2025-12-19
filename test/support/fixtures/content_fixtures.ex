defmodule Sammelana.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sammelana.Content` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description",
        images: ["option1", "option2"],
        title: "some title"
      })
      |> Sammelana.Content.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      %{
        body: "some body"
      }
      |> Map.merge(attrs)
      |> Sammelana.Content.create_comment()

    comment
  end

  @doc """
  Generate a like.
  """
  def like_fixture(attrs \\ %{}) do
    {:ok, like} =
      attrs
      |> Enum.into(%{
        meta: %{}
      })
      |> Sammelana.Content.create_like()

    like
  end
end
