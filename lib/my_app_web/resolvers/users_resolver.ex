defmodule MyAppWeb.UsersResolver do
  alias MyApp.Auth

  def all_users(_root, _args, _info) do
    {:ok, Auth.list_users()}
  end

  def create_user(_root, args, _info) do
    case Auth.create_user(args) do
      {:ok, user} ->
        {:ok, user}
      _error ->
        {:error, "could not create user"}
    end
  end

  def authenticate_user(_root, %{email: email, password: password}, _info) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        token = Auth.sign(%{id: user.id})
        {:ok, %{token: token, user: user }}
      {:error, message} ->
        {:error, message}  
    end
  end
end