defmodule MyAppWeb.DeedsResolver do
  alias MyApp.Rewards

  def all_deeds(_, _, _) do
    {:ok, Rewards.list_deeds()}
  end

  def create_deed(_root, %{input: args}, _info) do
    case Rewards.create_deed(args) do
      {:ok, deed} ->
        {:ok, deed}

      {:error, _} ->
        {:error, "error creating deed"}
    end
  end

  def delete_deed(_root, %{id: id}, _info) do
    case Rewards.delete_deed_with_id(id) do
      {:ok, deed} ->
        resp = Map.put(deed, :action, "deleted")
        {:ok, resp}

      {:error, _} ->
        {:error, "error deleting deed"}
    end
  end

  def edit_deed(_root, %{input: %{id: id, description: description}}, _info) do
    Rewards.get_deed!(id)
    |> Rewards.update_deed(%{description: description})
  end

  def add_star(_root, %{input: %{id: id, action: action}}, _info) do
    with deed <- Rewards.get_deed!(id) do
      case action do
        "plus" ->
          Rewards.update_deed(deed, %{stars: deed.stars + 1})

        "minus" ->
          if deed.stars != 0 do
            Rewards.update_deed(deed, %{stars: deed.stars - 1})
          else
            {:error, "no stars to minus"}
          end

        _ ->
          {:error, "Invalid action"}
      end
    end
  end
end
