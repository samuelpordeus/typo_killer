defmodule TypoKiller.WordsParser do
  def files_to_words(files) do
    files
    |> Enum.flat_map(&find_words/1)
    |> MapSet.new()
  end

  defp find_words(file) do
    file
    |> File.read!()
    |> String.downcase()
    |> String.split(["\n", "_", " "], trim: true)
    |> Enum.flat_map(&Regex.split(~r/[^a-zA-Z]+/, &1, trim: true))
  end
end
