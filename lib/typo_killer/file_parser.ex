defmodule TypoKiller.FileParser do
  @moduledoc """
  Parse all files and concat paths to folder to generate a complete list of files ready to be read
  """

  @doc """
  Find files inside path.

  - When path is a file, it returns itself inside a list
  - When path is a directory, scan the entire folder and subfolders for files
  - When path is something different, it returns an empty list
  """
  @spec find_files_on_folder(path :: String.t) :: list(String.t) | []
  def find_files_on_folder(path \\ ".") do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) && !String.contains?(path, "/_") ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&find_files_on_folder/1)
        |> Enum.concat()

      true ->
        []
    end
  end
end
