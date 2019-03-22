defmodule GraphQL.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias GraphQL.UserResolvers

  object :user_queries do
    connection field(:users, node_type: :user) do
      arg(:filter, :user_filter)
      # arg :order, type: :sort_order, default_value: :asc
      resolve(&UserResolvers.list_users/3)
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