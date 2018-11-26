defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.UsersResolver
  alias MyAppWeb.Middleware

  query do
    @desc "Get all users"
    field :all_users, list_of(:user) do
      middleware Middleware.Authorize, :any
      resolve &UsersResolver.all_users/3
    end
  end

  mutation do
    field :create_user, :user do
      arg :input, non_null(:create_user_input)
      middleware Middleware.Authorize, "admin"
      resolve &UsersResolver.create_user/3
    end

    field :sign_in_user, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &UsersResolver.authenticate_user/3
    end
  end

  input_object :create_user_input do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
    field :password, non_null(:string)
    field :role, non_null(:string)
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  object :user do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
  end

end