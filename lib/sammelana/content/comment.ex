defmodule Sammelana.Content.Comment do
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :user_id, :binary_id
    field :post_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id, :post_id])
    |> validate_required([:body, :user_id, :post_id])
  end
end
