defmodule TypoKiller.Finder do
  @moduledoc """
  Find typos based on percentage and try to avoid the max of possible false positives
  """
  @minimum_bag_distance 0.75
  @minimum_jaro_distance 0.95

  @doc """
  Based on a list of words, generate possible typos with an English dictionary
  """
  @spec find_typos({list_of_words :: list(String.t), dictionary :: list(String.t)}) :: list(String.t)
  def find_typos({list_of_words, dictionary}) do
    list_of_words
    |> Enum.map(&Task.async(fn -> calculate_distance(&1, dictionary) end))
    |> Enum.flat_map(&Task.await(&1, :infinity))
    |> clean_words_list()
  end

  @spec calculate_distance(word :: String.t, dict :: list(String.t)) :: list(String.t | nil)
  defp calculate_distance(word, dict) do
    dict
    |> Enum.map(fn word_from_dict ->
      bag_distance = String.bag_distance(word, word_from_dict)

      with true <- bag_distance >= @minimum_bag_distance,
           jaro_distance <- String.jaro_distance(word, word_from_dict),
           true <- jaro_distance >= @minimum_jaro_distance and jaro_distance < 1.0 do
        word
      else
        false -> nil
      end
    end)
  end
end
