defmodule MyApp.RewardsTest do
  use MyApp.DataCase

  alias MyApp.Rewards

  describe "deeds" do
    alias MyApp.Rewards.Deed

    @valid_attrs %{description: "some description", stars: 42}
    @update_attrs %{description: "some updated description", stars: 43}
    @invalid_attrs %{description: nil, stars: nil}

    def deed_fixture(attrs \\ %{}) do
      {:ok, deed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rewards.create_deed()

      deed
    end

    test "list_deeds/0 returns all deeds" do
      deed = deed_fixture()
      assert Rewards.list_deeds() == [deed]
    end

    test "get_deed!/1 returns the deed with given id" do
      deed = deed_fixture()
      assert Rewards.get_deed!(deed.id) == deed
    end

    test "create_deed/1 with valid data creates a deed" do
      assert {:ok, %Deed{} = deed} = Rewards.create_deed(@valid_attrs)
      assert deed.description == "some description"
      assert deed.stars == 42
    end

    test "create_deed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rewards.create_deed(@invalid_attrs)
    end

    test "update_deed/2 with valid data updates the deed" do
      deed = deed_fixture()
      assert {:ok, %Deed{} = deed} = Rewards.update_deed(deed, @update_attrs)
      assert deed.description == "some updated description"
      assert deed.stars == 43
    end

    test "update_deed/2 with invalid data returns error changeset" do
      deed = deed_fixture()
      assert {:error, %Ecto.Changeset{}} = Rewards.update_deed(deed, @invalid_attrs)
      assert deed == Rewards.get_deed!(deed.id)
    end

    test "delete_deed/1 deletes the deed" do
      deed = deed_fixture()
      assert {:ok, %Deed{}} = Rewards.delete_deed(deed)
      assert_raise Ecto.NoResultsError, fn -> Rewards.get_deed!(deed.id) end
    end

    test "change_deed/1 returns a deed changeset" do
      deed = deed_fixture()
      assert %Ecto.Changeset{} = Rewards.change_deed(deed)
    end
  end
end
