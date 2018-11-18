defmodule MyAppWeb.UsersResolver do
  alias MyApp.Auth

  def all_users(_root, _args, _info) do
    {:ok, Auth.list_users()}
  end
end