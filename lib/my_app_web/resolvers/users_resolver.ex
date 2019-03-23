defmodule MyAppWeb.UsersResolver do
  alias MyApp.Auth

  # def all_users(_root, _args, _info) do
  #   {:ok, Auth.list_users()}
  # end

  # def create_user(_root, args, %{context: context}) do
  def create_user(_root, %{input: args}, _) do
    case Auth.create_user(args) do
      {:ok, user} ->
        {:ok, user}
      {:error, _} ->
        # {:error, error}
        {:error, "error in insert"}
    end
  end

  def authenticate_user(_root, %{email: email, password: password}, _info) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        token = Auth.sign(%{id: user.id})
        IO.inspect(token, label: 'token here')
        {:ok, %{token: token, user: user }}
      {:error, message} ->
        {:error, message}  
    end
  end
end