defmodule Mix.Tasks.TypoKiller do
  use Mix.Task

  @shortdoc "Runs TypoKiller in the given directories"
  @spec run(directory :: list(String.t()) | []) :: :ok
  def run(directory) do
    directory
    |> parse_directory()
    |> TypoKiller.find_typos()
  end

  @spec parse_directory(directory :: list(String.t()) | []) :: binary()
  defp parse_directory([dir]), do: dir
  defp parse_directory([]), do: "."
end
