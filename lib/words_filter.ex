defmodule TypoKiller.WordsFilter do
  def clean_data(files) do
    Enum.flat_map(files, &find_words/1) |> Enum.uniq()
  end

  def remove_english_words(possible_typos) do
    Enum.filter(possible_typos, fn el ->
      !Enum.member?(Dictionary.aux_dictionary(), el)
    end)
  end

  defp find_words(file) do
    file
    |> File.read!()
    |> String.downcase()
    |> String.split(["\n", "_", " "], trim: true)
    |> Enum.flat_map(&Regex.split(~r/[^a-zA-Z]+/, &1, trim: true))
  end
end
