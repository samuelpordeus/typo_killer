defmodule TypoKiller.Words do
  @moduledoc """
  Extracts words from files.
  """

  alias TypoKiller.Dictionary

  @doc """
  Parses a list of files to extract words and their occurrences (file and line)
  """
  @spec files_to_words(files :: list(String.t()) | []) :: {MapSet.t(), map}
  def files_to_words(files)

  def files_to_words(files) when is_list(files) and length(files) == 0, do: {MapSet.new(), %{}}

  def files_to_words(files) when is_list(files) and length(files) > 0 do
    files
    |> Flow.from_enumerable()
    |> Flow.map(&parse_file/1)
    |> Enum.to_list()
    |> Enum.reduce({MapSet.new(), %{}}, &merge_file_list_results/2)
  end

  defp parse_file(file) do
    word_map =
      file
      |> File.stream!()
      |> Stream.with_index(1)
      |> Stream.map(&parse_line/1)
      |> Enum.reduce(%{}, &merge_file_results/2)

    words =
      word_map
      |> Map.keys()
      |> MapSet.new()

    {file, words, word_map}
  end

  defp merge_file_list_results({file, words, word_map}, {acc_words, acc_map}) do
    updated_words = MapSet.union(words, acc_words)

    updated_acc_map =
      Enum.reduce(word_map, acc_map, fn {word, lines}, acc ->
        occurrences = Map.get(acc, word, [])
        updated_occurrences = [{file, lines} | occurrences]
        Map.put(acc, word, updated_occurrences)
      end)

    {updated_words, updated_acc_map}
  end

  defp parse_line({line, number}) do
    line
    |> String.downcase()
    |> String.split(["_", " "], trim: true)
    |> Enum.flat_map(&split_function/1)
    |> Enum.filter(&ignore_words_filter/1)
    |> Map.new(&{&1, [number]})
  end

  defp split_function(word) do
    Regex.split(~r/[^a-zA-Z]+/, word, trim: true)
  end

  defp ignore_words_filter(word) do
    !MapSet.member?(Dictionary.ignored_words_mapset(), word)
  end

  defp merge_file_results(entry, acc) do
    Map.merge(entry, acc, fn _key, v1, v2 ->
      v1 ++ v2
    end)
  end
end
