defmodule TypoKiller.WordsFilter do
  def remove_english_words(possible_typos) do
    Enum.filter(possible_typos, fn el ->
      !Enum.member?(Dictionary.aux_dictionary(), el)
    end)
  end
end
