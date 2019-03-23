defmodule GraphQL.PostResolvers do
  
  def all_posts(_, args, _) do
    Absinthe.Relay.Connection.from_query(
      query(args),
      &MyApp.Dars.list_posts/1,
      args
    )
  end

  def query(args) do
    Enum.reduce(args, MyApp.Dars.Post, fn
      _, query ->
        query
    end)
  end
end