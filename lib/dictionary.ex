defmodule Dictionary do
  alias TypoKiller.WordsFilter

  @aux_dictionary_path "./priv/ignored_words.txt"

  def create(words) do
    dictionary = words ++ aux_dictionary()
    words = WordsFilter.remove_english_words(words)

    %{list_of_words: words, dictionary: dictionary}
  end

  def aux_dictionary() do
    @aux_dictionary_path
    |> File.read!()
    |> String.split("\n")
  end
end
