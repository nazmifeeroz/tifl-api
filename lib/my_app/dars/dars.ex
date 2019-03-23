defmodule MyApp.Dars do
  @moduledoc """
  The Dars context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Dars.Post

  def list_posts(query) do
    args = from q in query,
    order_by: [ desc: q.inserted_at ]
    Repo.all(args)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end
end