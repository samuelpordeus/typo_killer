defmodule TypoKiller.Dictionary do
  @ignored_words_list "./priv/ignored_words.txt"
                      |> File.read!()
                      |> String.split("\n")

  @ignored_words_mapset MapSet.new(@ignored_words_list)

  def create(words) do
    dictionary = MapSet.union(words, @ignored_words_mapset)
    words = MapSet.difference(words, @ignored_words_mapset)

    {words, dictionary}
  end

  def aux_dictionary, do: @ignored_words_list
end
