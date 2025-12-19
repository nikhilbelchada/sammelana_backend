defmodule Sammelana.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sammelana.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        email: "some email",
        mobileno: "some mobileno",
        name: "some name"
      })
      |> Sammelana.Accounts.create_user()

    user
  end
end
