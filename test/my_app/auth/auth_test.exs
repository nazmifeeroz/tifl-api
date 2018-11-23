defmodule MyApp.AuthTest do
  use MyApp.DataCase
  use Phoenix.ConnTest

  @endpoint MyAppWeb.Endpoint

  alias MyApp.Auth

  describe "users" do
    alias MyApp.Auth.User

    @valid_attrs %{email: "some email", is_active: true, password: "some password"}
    @update_attrs %{email: "some updated email", is_active: false, password: "some updated password"}
    @invalid_attrs %{email: nil, is_active: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [%User{user | password: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == %User{user | password: nil}
    end

    @query """
    {
      allUsers {
        email
        isActive
      }
    }
    """
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_active == true
      assert Bcrypt.verify_pass("some password", user.password_hash)
      conn = build_conn()
      conn = get conn, "/api", query: @query
      assert json_response(conn, 200) == %{
        "data" => 
          %{"allUsers" => [
            %{"email" => "some email", "isActive" => true}
            ]
          }
        }
    end

    @query """
    mutation ($email: String!, $password: String!) {
      signInUser(email: $email, password: $password) {
        user {
          email
          isActive
        }
      }
    }
    """
    test "sign in correctly" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      conn = build_conn()
      conn = post conn, "/api", query: @query, variables: @valid_attrs
      assert json_response(conn, 200) == %{
        "data" => %{
          "signInUser" => %{ 
            "user" => %{ 
              "email" => "some email", "isActive" => true
            } 
          }
        }
      }
    end
    test "invalid sign in" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      conn = build_conn()
      conn = post conn, "/api", query: @query, variables: @invalid_attrs
      %{"errors" => [%{"locations" => [%{"column" => 0, "line" => 2}], "message" => message}, 
      %{"locations" => [%{"column" => 0, "line" => 2}], "message" => "Argument \"password\" has invalid value $password."}, 
      %{"locations" => [%{"column" => 0, "line" => 1}], "message" => "Variable \"email\": Expected non-null, found null."}, 
      %{"locations" => [%{"column" => 0, "line" => 1}], "message" => "Variable \"password\": Expected non-null, found null."}
      ]} = json_response(conn, 200)
      assert message == "Argument \"email\" has invalid value $email."
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.is_active == false
      assert Bcrypt.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert %User{user | password: nil} == Auth.get_user!(user.id)
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
