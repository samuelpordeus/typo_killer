defmodule TypoKiller do
  @moduledoc """
  Qu'est-ce que c'est

  Fa-fa-fa-fa-fa-fa-fa-fa-fa

  It's a funny app to search typos inside projects and report
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
  @spec find_typos(path :: binary()) :: :ok | {:error, String.t}
  def find_typos(path \\ ".") do
    path
    |> FileParser.find_files_on_folder()
    |> WordsParser.files_to_words()
    |> Dictionary.create()
    |> Finder.find_typos()
    |> print_typo_candidates()
  end

  @spec print_typo_candidates(possible_typos :: MapSet.t) :: :ok | {:error, String.t}
  defp print_typo_candidates(possible_typos) do
    Logger.info("There are #{MapSet.size(possible_typos)} possible typos on your folder!")

    if MapSet.size(possible_typos) > 0 do
      Logger.info("Here are the official typo candidates:")

      possible_typos
      |> Enum.each(&Logger.info("Typo found: #{&1}"))
    end

    :ok
  end

  @doc """
  Execute the benchmark for `find_typos` function
  """
  @spec benchmark_find_typos(path :: String.t) :: any
  def benchmark_find_typos(path \\ ".") do
    %{"find_typos" => fn -> find_typos(path) end}
    |> Benchee.run(time: 1, memory_time: 1)
  end
end
