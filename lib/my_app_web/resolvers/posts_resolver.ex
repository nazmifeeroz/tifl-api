defmodule MyAppWeb.PostsResolver do
  alias MyApp.Dars

  def all_posts(_root, _args, _info) do
    {:ok, Dars.list_posts()}
  end
end