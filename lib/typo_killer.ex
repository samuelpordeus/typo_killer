defmodule TypoKiller do
  alias TypoKiller.Dictionary
  alias TypoKiller.FileParser
  alias TypoKiller.WordsParser
  alias TypoKiller.Finder

  def find_typos(path \\ ".") do
    path
    |> FileParser.find_files_on_folder()
    |> WordsParser.files_to_words()
    |> Dictionary.create()
    |> Finder.find_typos()
    |> print_typo_candidates()
  end

  defp print_typo_candidates(possible_typos) do
    IO.puts("There are #{MapSet.size(possible_typos)} possible typos on your folder!")
    IO.puts("Here are the official typo candidates:")
    Enum.each(possible_typos, fn typo -> IO.puts(typo) end)
  end

  def benchmark_find_typos(path \\ ".") do
    Benchee.run(
      %{
        "find_typos" => fn -> find_typos(path) end
      },
      time: 1,
      memory_time: 1
    )
  end
end
