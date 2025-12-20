defmodule Sammelana.Content.Like do
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :meta, :map
    field :user_id, :binary_id
    field :post_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:meta, :user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
