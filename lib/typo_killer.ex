defmodule TypoKiller do
  @moduledoc """
  Qu'est-ce que c'est

  Fa-fa-fa-fa-fa-fa-fa-fa-fa

  It's a funny app to search wrong typos inside projects and report
  the words that can be fixed and, with this project, you can
  contribute to open-source repos with the famous `Fix typo` commits/PRs.
  """
  require Logger
  alias TypoKiller.Dictionary
  alias TypoKiller.FileParser
  alias TypoKiller.WordsParser
  alias TypoKiller.Finder

  @doc """
  Scan a folder, find all possible typos and log them
  """
  @spec find_typos(path :: binary()) :: :ok
  def find_typos(path \\ ".") do
    path
    |> FileParser.find_files_on_folder()
    |> WordsParser.files_to_words()
    |> Dictionary.create()
    |> Finder.find_typos()
    |> print_typo_candidates()
  end

  defp print_typo_candidates(possible_typos) do
    IO.puts("There are #{length(possible_typos)} possible typos on your folder!")
    IO.puts("Here are the official typo candidates:")
    Enum.each(possible_typos, fn typo -> IO.puts(typo) end)
  end

  @doc """
  Execute the benchmark for `find_typos` function
  """
  @spec benchmark_find_typos(path :: String.t) :: any
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
