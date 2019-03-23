defmodule GraphQL.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias MyAppWeb.Middleware
  alias GraphQL.PostResolvers

  object :post_queries do
    connection field(:all_posts, node_type: :post) do
      arg(:filter, :post_filter)
      middleware Middleware.Authorize, :any
      resolve(&PostResolvers.all_posts/3)
    end
  end

  node object(:post) do
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :image, :string
    field :inserted_at, :string
  end

  connection(node_type: :post)

  input_object :post_filter do
    field(:title, :string)
  end
end