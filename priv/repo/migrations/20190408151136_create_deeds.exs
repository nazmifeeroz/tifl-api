defmodule MyApp.Repo.Migrations.CreateDeeds do
  use Ecto.Migration

  def change do
    create table(:deeds) do
      add :description, :string
      add :stars, :integer

      timestamps()
    end
  end
end
