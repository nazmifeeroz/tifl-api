defmodule GraphQL.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias GraphQL.UserResolvers
  alias MyAppWeb.UsersResolver
  alias MyAppWeb.Middleware

  object :user_queries do
    connection field(:all_users, node_type: :user) do
      arg(:filter, :user_filter)
      # arg :order, type: :sort_order, default_value: :asc
      middleware Middleware.Authorize, :any
      resolve(&UserResolvers.all_users/3)
    end
  end

  object :user_mutations do
    payload field :sign_in_user do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
      end

      output do
        field :user, :user
        field :token, :string
      end

      resolve(&UsersResolver.authenticate_user/3)
    end
  end

  node object(:user) do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
  end

  connection(node_type: :user)

  input_object :user_filter do
    field(:email, :string)
  end 

end