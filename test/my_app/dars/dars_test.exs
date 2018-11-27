defmodule MyApp.DarsTest do
  use MyApp.DataCase
  use Phoenix.ConnTest

  @endpoint MyAppWeb.Endpoint

  alias MyApp.Dars
  alias MyApp.Auth
  alias MyApp.Auth.User

  describe "dars" do
    
    @post_attrs %{title: "some title", body: "some body"}
    @user_attrs %{email: "some email", is_active: true, password: "some password", role: "admin"}

    defp auth_user(conn, user) do
      token = MyApp.Auth.sign(%{id: user.id})
      put_req_header(conn, "authorization", "Bearer #{token}")
    end

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@post_attrs)
        |> Dars.create_post()

      post
    end

    @query """
    {
      allPosts {
        title
        body
      }
    }
    """
    test "list_posts returns all post" do
      post = post_fixture()
      assert Dars.list_posts() == [post]
    end

    @query """
    mutation ($createPostInput: CreatePostInput!) {
      createPost(input: $createPostInput) {
        title
        body
      }
    }
    """
    test "create_post" do
      assert {:ok, %User{} = user} = Auth.create_user(@user_attrs)
      conn = build_conn() |> auth_user(user)

      conn = post conn, "/api",
        query: @query,
        variables: %{"createPostInput" => @post_attrs}

      assert json_response(conn, 200) == %{
          "data" => %{
            "createPost" => %{
              "body" => "some body",
              "title" => "some title"
            }
          }
        }
        
    end

    test "create post" do
      
    end
  end
end