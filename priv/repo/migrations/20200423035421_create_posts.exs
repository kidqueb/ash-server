defmodule AshServer.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string
      add :is_public, :string

      timestamps()
    end

  end
end
