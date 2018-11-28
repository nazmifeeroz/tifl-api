defmodule MyApp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :user_id, references(:users)
      add :post_id, references(:posts)

      add :comment, :text
      add :commented_at, :utc_datetime, null: false, default: fragment("NOW()")
      add :state, :string, null: false, default: "created"

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:post_id])
  end
end
