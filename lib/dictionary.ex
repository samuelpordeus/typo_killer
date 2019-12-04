defmodule Dictionary do
  alias TypoKiller.WordsFilter

  @ignored_words "./priv/ignored_words.txt"
                 |> File.read!()
                 |> String.split("\n")

  def create(words) do
    dictionary = words ++ aux_dictionary()
    words = WordsFilter.remove_english_words(words)

    %{list_of_words: words, dictionary: dictionary}
  end

  def aux_dictionary, do: @ignored_words
end
