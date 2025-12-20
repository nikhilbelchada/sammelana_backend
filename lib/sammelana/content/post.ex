defmodule Sammelana.Content.Post do
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :description, :string
    field :images, {:array, :string}, default: []

    belongs_to :user, Sammelana.Accounts.User, type: :binary_id
    has_many :comments, Sammelana.Content.Comment
    has_many :likes, Sammelana.Content.Like

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :images, :user_id])
    |> validate_required([:title, :description, :images, :user_id])
  end
end
