defmodule MyApp.Rewards.Deed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deeds" do
    field :description, :string
    field :stars, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(deed, attrs) do
    deed
    |> cast(attrs, [:description, :stars])
    |> validate_required([:description, :stars])
  end
end
