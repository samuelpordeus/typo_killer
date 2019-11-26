defmodule TypoKiller.Finder do
  alias TypoKiller.WordsFilter
  @minimum_bag_distance 0.75
  @minimum_jaro_distance 0.95

  def find_typos(%{list_of_words: list_of_words, dictionary: dictionary}) do
    list_of_words
    |> Enum.map(&Task.async(fn -> calculate_distance(&1, dictionary) end))
    |> Enum.flat_map(&Task.await(&1, :infinity))
    |> clean_words_list()
  end

  defp calculate_distance(word, dict) do
    Enum.map(dict, fn word_from_dict ->
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

  defp clean_words_list(list_of_words) do
    list_of_words
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
    |> WordsFilter.remove_english_words()
  end

  # IO.puts("----------------------------------------------------------")
  # IO.puts("word: #{word}")
  # IO.puts("bag_distance: #{bag_distance}")
  # IO.puts("jaro_distance: #{jaro_distance}")
  # IO.puts("----------------------------------------------------------")
end
