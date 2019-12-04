defmodule TypoKiller.Dictionary do
  @ignored_words_list "./priv/ignored_words.txt"
                      |> File.read!()
                      |> String.split("\n")

  @ignored_words_mapset MapSet.new(@ignored_words_list)

  def create(words) do
    dictionary = words ++ aux_dictionary()
    words = remove_ignored_words(words)

    {words, dictionary}
  end

  def aux_dictionary, do: @ignored_words_list

  def remove_ignored_words(words) do
    words
    |> MapSet.new()
    |> MapSet.difference(@ignored_words_mapset)
    |> MapSet.to_list()
  end
end
