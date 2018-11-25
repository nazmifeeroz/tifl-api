defmodule MyApp.Repo.Migrations.AddRoleColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, null: false
    end
  end
end
