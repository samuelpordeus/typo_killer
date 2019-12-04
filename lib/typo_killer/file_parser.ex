defmodule TypoKiller.FileParser do
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
