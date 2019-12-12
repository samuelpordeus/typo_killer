defmodule TypoKiller.Finder do
  @moduledoc """
  Find typos
  """
  @minimum_jaro_distance 0.95

  @doc """
  Based on a list of words, search for possible typos by comparing them with an auxiliar dictionary
  """
  @spec find_typos({words :: MapSet.t(), dictionary :: MapSet.t()}) :: MapSet.t()

  def find_typos({words, dictionary, word_map}) do
    candidates =
      words
      |> Flow.from_enumerable(max_demand: 100)
      |> Flow.map(fn word -> calculate_distance(word, dictionary) end)
      |> Flow.reduce(fn -> MapSet.new() end, &merge_partial_result/2)
      |> MapSet.new()
      |> MapSet.delete(nil)
      |> Enum.to_list()

    Map.take(word_map, candidates)
  end

  defp merge_partial_result(partial_result, acc) do
    partial_result_mapset = MapSet.new(partial_result)
    MapSet.union(partial_result_mapset, acc)
  end

  @spec calculate_distance(word :: String.t(), dict :: list(String.t())) :: list(String.t() | nil)
  defp calculate_distance(word, dict) do
    dict
    |> Enum.map(fn word_from_dict ->
      with jaro_distance <- String.jaro_distance(word, word_from_dict),
           true <- jaro_distance >= @minimum_jaro_distance and jaro_distance < 1.0 do
        word
      else
        false -> nil
      end
    end)
  end
end
