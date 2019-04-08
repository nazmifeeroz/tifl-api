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
