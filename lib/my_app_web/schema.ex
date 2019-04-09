defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.UsersResolver
  alias MyAppWeb.PostsResolver
  alias MyAppWeb.DeedsResolver
  alias MyAppWeb.Middleware

  query do
    @desc "Get all users"
    field :all_users, list_of(:user) do
      middleware(Middleware.Authorize, :any)
      resolve(&UsersResolver.all_users/3)
    end

    @desc "Get all posts"
    field :all_posts, list_of(:post) do
      middleware(Middleware.Authorize, :any)
      resolve(&PostsResolver.all_posts/3)
    end

    @desc "Get all deeds"
    field :all_deeds, list_of(:deed) do
      middleware(Middleware.Authorize, :any)
      resolve(&DeedsResolver.all_deeds/3)
    end
  end

  mutation do
    field :create_user, :user do
      arg(:input, non_null(:create_user_input))
      middleware(Middleware.Authorize, "admin")
      resolve(&UsersResolver.create_user/3)
    end

    field :sign_in_user, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&UsersResolver.authenticate_user/3)
    end

    field :create_post, :post do
      arg(:input, non_null(:create_post_input))
      middleware(Middleware.Authorize, "admin")
      resolve(&PostsResolver.create_post/3)
    end

    field :create_deed, :deed do
      arg(:input, non_null(:create_deed_input))
      middleware(Middleware.Authorize, "admin")
      resolve(&DeedsResolver.create_deed/3)
    end

    field :edit_deed, :deed do
      arg(:input, non_null(:edit_deed_input))
      middleware(Middleware.Authorize, "admin")
      resolve(&DeedsResolver.edit_deed/3)
    end

    field :add_star, :deed do
      arg(:input, non_null(:add_star_input))
      middleware(Middleware.Authorize, "admin")
      resolve(&DeedsResolver.add_star/3)
    end

    field :delete_post, :post do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize, "admin")
      resolve(&PostsResolver.delete_post/3)
    end
  end

  subscription do
    field :new_post, :post do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)

      trigger(
        [:create_post],
        topic: fn _payload ->
          "*"
        end
      )
    end

    field :new_deed, :deed do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)

      trigger(
        [:create_deed],
        topic: fn _payload ->
          "*"
        end
      )

    end
  end

  input_object :create_post_input do
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :image, :string
  end

  input_object :create_user_input do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
    field :password, non_null(:string)
    field :role, non_null(:string)
  end

  input_object :create_deed_input do
    field :description, non_null(:string)
  end

  input_object :edit_deed_input do
    field :id, non_null(:id)
    field :description, non_null(:string)
  end

  input_object :add_star_input do
    field :id, non_null(:id)
    field :action, non_null(:string)
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  object :user do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :image, :string
    field :inserted_at, :string
  end

  object :deed do
    field :id, non_null(:id)
    field :description, non_null(:string)
    field :stars, non_null(:integer)
  end
end
