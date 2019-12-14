defmodule TypoKiller.Typos do
  @moduledoc """
  Find typos
  """
  @minimum_jaro_distance 0.95
  @default_max_demand 100

  @doc """
  Based on a list of words, search for possible typos by comparing them with an auxiliar dictionary
  """
  @spec find(
          {words :: MapSet.t(), dictionary :: MapSet.t(), word_map :: Map.t()},
          options :: Keyword.t()
        ) :: Map.t()
  def find({words, dictionary, word_map}, options \\ []) do
    max_demand = options[:max_demand] || @default_max_demand

    words
    |> Flow.from_enumerable(max_demand: max_demand)
    |> Flow.map(fn word -> calculate_distance(word, dictionary) end)
    |> Flow.reduce(fn -> MapSet.new() end, &merge_partial_result/2)
    |> Flow.map(fn candidate -> build_result_map(candidate, word_map) end)
    |> MapSet.new()
    |> MapSet.delete(nil)
    |> MapSet.to_list()
    |> Map.new()
  end

  defp merge_partial_result(partial_result, acc) do
    partial_result_mapset = MapSet.new(partial_result)
    MapSet.union(partial_result_mapset, acc)
  end

  defp calculate_distance(word, dict) do
    dict
    |> Enum.map(fn word_from_dict ->
      with jaro_distance <- String.jaro_distance(word, word_from_dict),
           true <- jaro_distance >= @minimum_jaro_distance and jaro_distance < 1.0 do
        {word, word_from_dict, jaro_distance}
      else
        _any -> nil
      end
    end)
  end

  defp build_result_map(nil, _), do: nil

  defp build_result_map({word, match, score}, word_map) do
    {word, {match, score, Map.get(word_map, word)}}
  end
end
