defmodule Sammelana.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :mobileno, :string
      add :email, :string
      add :bio, :text

      timestamps(type: :utc_datetime)
    end
  end
end
