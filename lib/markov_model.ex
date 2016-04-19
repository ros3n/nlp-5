defmodule MarkovModel do
  def build_model(digrams) do
    digrams
    |> Enum.reduce(%{}, fn ({a, b}, model) -> add_edge(model, a, b) end)
    |> calculate_weights
  end

  defp add_edge(model, a, b) do
    case model do
      %{^a => %{^b => n}} ->
        put_in model[a][b], n + 1
      %{^a => %{}} ->
        put_in model[a][b], 1
      _ ->
        Map.put(model, a, %{b => 1})
    end
  end

  defp calculate_weights(model) do
    model
    |> Enum.reduce(%{}, fn ({v, edges}, model) -> Map.put(model, v, weighted_edges(edges)) end)
  end

  defp weighted_edges(edges) do
    sum = Enum.reduce(edges, 0, fn ({_, v}, acc) -> acc + v end)
    edges
    |> Enum.reduce(%{}, fn ({k, v}, model) -> Map.put(model, k, v / sum) end)
  end
end
