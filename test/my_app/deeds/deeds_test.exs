defmodule MyApp.DeedsTest do
  use MyApp.DataCase
  use Phoenix.ConnTest

  @endpoint MyAppWeb.Endpoint

  alias MyApp.Rewards
  alias MyApp.Auth
  alias MyApp.Auth.User

  describe "Rewards Schema" do
    @deed_attrs %{description: "Some description"}
    @user_attrs %{
      email: "some email",
      is_active: true,
      password: "some password",
      role: "admin"
    }
    @assert_attr %{
      "description" => "Some description",
      "stars" => 0
    }

    defp auth_user(conn, user) do
      token = Auth.sign(%{id: user.id})
      put_req_header(conn, "authorization", "Bearer #{token}")
    end

    def deeds_fixture(attrs \\ %{}) do
      {:ok, deed} =
        attrs
        |> Enum.into(@deed_attrs)
        |> Rewards.create_deed()

      deed
    end

    setup do
      {:ok, %User{} = user} = Auth.create_user(@user_attrs)

      deed = deeds_fixture()
      conn = build_conn() |> auth_user(user)

      {:ok, %{conn: conn, deed: deed}}
    end

    @query """
    {
      allDeeds {
        description
        stars
      }
    }
    """
    test "all_deeds returns all deeds", %{conn: conn} do
      conn = post conn, "/api", query: @query

      assert json_response(conn, 200) == %{
               "data" => %{
                 "allDeeds" => [
                   @assert_attr
                 ]
               }
             }
    end

    @query """
    mutation ($createDeedInput: CreateDeedInput!) {
      createDeed(input: $createDeedInput) {
        description
        stars
      }
    }
    """
    test "create deed", %{conn: conn} do
      conn =
        post conn, "/api",
          query: @query,
          variables: %{"createDeedInput" => @deed_attrs}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createDeed" => @assert_attr
               }
             }
    end

    @query """
    mutation ($editDeedInput: EditDeedInput!) {
      editDeed(input: $editDeedInput) {
        description
        stars
      }
    }
    """
    test "edit deed", %{conn: conn, deed: deed} do
      conn =
        post conn, "/api",
          query: @query,
          variables: %{
            "editDeedInput" => %{
              id: deed.id,
              description: "new description"
            }
          }

      assert json_response(conn, 200) == %{
               "data" => %{
                 "editDeed" => %{
                   "description" => "new description",
                   "stars" => 0
                 }
               }
             }
    end

    @query """
    mutation ($addStarInput: AddStarInput!) {
      addStar(input: $addStarInput) {
        stars
      }
    }
    """
    test "add stars", %{conn: conn, deed: deed} do
      conn =
        post conn, "/api",
          query: @query,
          variables: %{
            "addStarInput" => %{
              id: deed.id,
              action: "plus"
            }
          }

      assert json_response(conn, 200) == %{
               "data" => %{
                 "addStar" => %{
                   "stars" => 1
                 }
               }
             }
    end

    test "minus stars should return error if star is 0", %{conn: conn, deed: deed} do
      conn =
        post conn, "/api",
          query: @query,
          variables: %{
            "addStarInput" => %{
              id: deed.id,
              action: "minus"
            }
          }

      resp = 
        json_response(conn, 200) 
        |> Map.get("errors") 
        |> List.first() 
        |> Map.get("message")

      assert resp == "no stars to minus"
    end
  end
end
