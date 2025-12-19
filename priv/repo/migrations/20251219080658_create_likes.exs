defmodule Sammelana.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :meta, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:likes, [:user_id])
    create index(:likes, [:post_id])
    create index(:likes, [:user_id, :post_id], unique: true)
  end
end
