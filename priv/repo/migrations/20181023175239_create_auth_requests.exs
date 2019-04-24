defmodule Ash.Repo.Migrations.CreateAuthRequests do
  use Ecto.Migration

  def change do
    create table(:auth_requests) do
      add :email, :string

      timestamps()
    end

  end
end
