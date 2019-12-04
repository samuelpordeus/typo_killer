defmodule TypoKiller.WordsParser do
  def files_to_words(files) do
    Enum.flat_map(files, &find_words/1) |> Enum.uniq()
  end

  defp find_words(file) do
    file
    |> File.read!()
    |> String.downcase()
    |> String.split(["\n", "_", " "], trim: true)
    |> Enum.flat_map(&Regex.split(~r/[^a-zA-Z]+/, &1, trim: true))
  end
end
