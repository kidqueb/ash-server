defmodule Ash.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
