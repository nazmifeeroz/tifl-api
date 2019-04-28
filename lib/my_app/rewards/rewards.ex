defmodule MyApp.Rewards do
  @moduledoc """
  The Rewards context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Rewards.Deed

  @doc """
  Returns the list of deeds.

  ## Examples

      iex> list_deeds()
      [%Deed{}, ...]

  """
  def list_deeds do
    Repo.all(from d in Deed, order_by: [ desc: d.id ])
  end

  @doc """
  Gets a single deed.

  Raises `Ecto.NoResultsError` if the Deed does not exist.

  ## Examples

      iex> get_deed!(123)
      %Deed{}

      iex> get_deed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deed!(id), do: Repo.get!(Deed, id)

  @doc """
  Creates a deed.

  ## Examples

      iex> create_deed(%{field: value})
      {:ok, %Deed{}}

      iex> create_deed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deed(attrs \\ %{}) do
    %Deed{}
    |> Deed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deed.

  ## Examples

      iex> update_deed(deed, %{field: new_value})
      {:ok, %Deed{}}

      iex> update_deed(deed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deed(%Deed{} = deed, attrs) do
    deed
    |> Deed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Deed.

  ## Examples

      iex> delete_deed(deed)
      {:ok, %Deed{}}

      iex> delete_deed(deed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deed_with_id(id) do
    get_deed!(id)
    |> Repo.delete()
  end

  def delete_deed(%Deed{} = deed) do
    Repo.delete(deed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deed changes.

  ## Examples

      iex> change_deed(deed)
      %Ecto.Changeset{source: %Deed{}}

  """
  def change_deed(%Deed{} = deed) do
    Deed.changeset(deed, %{})
  end
end
