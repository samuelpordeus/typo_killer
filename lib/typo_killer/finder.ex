defmodule TypoKiller.Finder do
  @minimum_bag_distance 0.75
  @minimum_jaro_distance 0.95

  def find_typos({words, dictionary}) do
    words
    |> Enum.map(&Task.async(fn -> calculate_distance(&1, dictionary) end))
    |> Enum.flat_map(&Task.await(&1, :infinity))
    |> MapSet.new()
    |> MapSet.delete(nil)
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
end
