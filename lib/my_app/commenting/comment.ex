defmodule MyApp.Commenting.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Commenting.Comment


  schema "comments" do
    field :commented_at, :utc_datetime
    field :state, :string
    field :comment, :string

    field :post_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:user_id, :post_id, :commented_at, :state])
    |> validate_required([:user_id, :post_id, :commented_at, :state])
  end
end
