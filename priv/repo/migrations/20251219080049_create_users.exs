defmodule Sammelana.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :mobileno, :string
      add :email, :string
      add :bio, :text

      timestamps(type: :utc_datetime)
    end
  end
end
