defmodule MyApp.DarsTest do
  use MyApp.DataCase
  use Phoenix.ConnTest

  @endpoint MyAppWeb.Endpoint

  alias MyApp.Dars

  describe "dars" do
    
    @valid_attrs %{title: "some title", body: "some body"}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dars.create_post()

      post
    end

    test "list_posts returns all post" do
      post = post_fixture()
      assert Dars.list_posts() == [post]
      # assert Dars.list_posts() == [%Post{post | body: nil}]
    end

  end
end