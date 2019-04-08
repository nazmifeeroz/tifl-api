defmodule MyApp.CommentingTest do
  use MyApp.DataCase

  alias MyApp.Commenting

  describe "comments" do
    alias MyApp.Commenting.Comment

    @valid_attrs %{
      commented_at: "2010-04-17T14:00:00Z",
      post: %{},
      state: "some state",
      user_id: 42
    }
    @update_attrs %{
      commented_at: "2011-05-18T15:01:01Z",
      post: %{},
      state: "some updated state",
      user_id: 43
    }
    @invalid_attrs %{commented_at: nil, post: nil, state: nil, user_id: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commenting.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Commenting.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Commenting.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Commenting.create_comment(@valid_attrs)
      assert comment.commented_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert comment.post == %{}
      assert comment.state == "some state"
      assert comment.user_id == 42
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commenting.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Commenting.update_comment(comment, @update_attrs)
      assert comment.commented_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert comment.post == %{}
      assert comment.state == "some updated state"
      assert comment.user_id == 43
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Commenting.update_comment(comment, @invalid_attrs)
      assert comment == Commenting.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Commenting.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Commenting.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Commenting.change_comment(comment)
    end
  end
end
