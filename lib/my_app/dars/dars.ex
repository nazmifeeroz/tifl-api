defmodule MyApp.Dars do
  @moduledoc """
  The Dars context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Dars.Post

  def list_posts do
    Repo.all(Post)
  end

  def get_post!(id) do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

end