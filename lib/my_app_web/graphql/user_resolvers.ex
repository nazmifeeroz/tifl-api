defmodule GraphQL.UserResolvers do
  alias MyApp.Auth
  alias MyApp.Auth.User

  def all_users(_, args, _) do
    Absinthe.Relay.Connection.from_query(
      query(args),
      &Auth.list_users/1,
      args
    )
  end

  def query(args) do
    Enum.reduce(args, User, fn
      _, query ->
        query
    end)
  end
end