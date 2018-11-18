defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.UsersResolver

  query do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:user))) do
      resolve &UsersResolver.all_users/3
    end
  end

  mutation do
    field :create_user, :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
    end
  end

  object :user do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
  end

end