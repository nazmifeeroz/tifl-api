defmodule MyAppWeb.PostsResolver do
  alias MyApp.Dars

  def all_posts(_root, _args, _info) do
    {:ok, Dars.list_posts()}
  end

  def create_post(_root, %{ input: args }, _info) do
    case Dars.create_post(args) do
      {:ok, post} ->
        {:ok, post}
      {:error, _} ->
        {:error, "error creating post"}
    end
  end

  def delete_post(_root, %{ id: id }, _info) do
    post = Dars.get_post!(id)
    case Dars.delete_post(post) do
      {:ok, post} ->
        {:ok, post}
      {:error, _} ->
        {:error, "error deleting post"}
    end
  end


end