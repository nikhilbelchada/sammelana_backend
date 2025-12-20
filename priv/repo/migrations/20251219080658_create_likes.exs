defmodule Sammelana.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :meta, :map
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:likes, [:user_id])
    create index(:likes, [:post_id])
    create index(:likes, [:user_id, :post_id], unique: true)
  end
end
