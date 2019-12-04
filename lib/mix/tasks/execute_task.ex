defmodule Mix.Tasks.TypoKiller do
  use Mix.Task

  @shortdoc "Runs TypoKiller in the given directories"
  def run(directory) do
    directory
    |> parse_directory()
    |> TypoKiller.find_typos()
  end

  defp parse_directory([dir]), do: dir
  defp parse_directory([]), do: "."
end