defmodule TypoKiller do
  @moduledoc """
  Qu'est-ce que c'est

  Fa-fa-fa-fa-fa-fa-fa-fa-fa

  It's a funny app to search typos inside projects and report
  the words that can be fixed and, with this project, you can
  contribute to open-source repos with the famous `Fix typo` commits/PRs.
  """
  require Logger
  alias TypoKiller.Files
  alias TypoKiller.Output
  alias TypoKiller.Typos
  alias TypoKiller.Words

  @doc """
  Scan a folder, find all possible typos and log them
  """
  @spec find_typos(path :: String.t(), options :: Keyword.t()) :: :ok | {:error, String.t()}
  def find_typos(path \\ ".", options \\ []) do
    IO.puts("Path: \"#{path}\"")

    if options != [] do
      IO.puts("Options:")

      Enum.each(options, fn
        {k, v} when is_list(v) ->
          IO.puts("  #{Atom.to_string(k)} -> #{Enum.join(v, ", ")}")

        {k, v} ->
          IO.puts("  #{Atom.to_string(k)} -> #{inspect(v)}")
      end)
    end

    IO.puts("---")
    IO.puts("Running...")

    path
    |> Files.find_files_on_folder(options)
    |> Words.files_to_words()
    |> Typos.find(options)
    |> Output.print_candidates()
  end

  @doc """
  Execute the benchmark for `find_typos` function
  """
  @spec benchmark_find_typos(path :: String.t()) :: any
  def benchmark_find_typos(path \\ ".") do
    %{"find_typos" => fn -> find_typos(path) end}
    |> Benchee.run(time: 1, memory_time: 1)
  end
end
