defmodule Sammelana.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :mobileno, :string
    field :bio, :string

    has_many :posts, Sammelana.Content.Post
    has_many :comments, Sammelana.Content.Comment
    has_many :likes, Sammelana.Content.Like

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :mobileno, :bio])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:mobileno)
  end
end
