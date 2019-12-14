defmodule TypoKiller.Files do
  @moduledoc """
  Parse all files and concat path to a folder to generate a complete list of files ready to be read
  """

  @default_options [
    # Defaults to 5KiB
    max_size: 1024 * 5,
    ignore_dot_files: true,
    allowed_extensions: [],
    blocked_extensions: [],
    allowed_paths: [],
    blocked_paths: []
  ]

  @doc """
  Find files inside path.

  - When path is a file, it returns itself inside a list
  - When path is a directory, scan the entire folder and subfolders for files
  - When path is something different, it returns an empty list
  """
  @spec find_files_on_folder(path :: String.t()) :: list(String.t()) | []
  def find_files_on_folder(path \\ ".", options \\ []) do
    options_map = build_options_map(options)
    find_files(path, options_map)
  end

  defp build_options_map(options) do
    @default_options
    |> Keyword.merge(options)
    |> Map.new(fn {key, value} ->
      case value do
        value when is_list(value) ->
          {key, MapSet.new(value)}

        value ->
          {key, value}
      end
    end)
  end

  defp find_files(path, %{max_size: max_size} = options) do
    cond do
      file_in_size_range?(path, max_size) and allowed_file_extension?(path, options) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.filter(&filter_dot_files(&1, options))
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&find_files(&1, options))
        |> Enum.concat()
        |> Enum.filter(&allowed_path?(&1, options))

      true ->
        []
    end
  end

  defp filter_dot_files(file, %{ignore_dot_files: ignore_it?}) do
    !(ignore_it? and String.starts_with?(file, "."))
  end

  defp file_in_size_range?(file, max_size, min_size \\ 0) do
    %File.Stat{size: size, type: type} = File.stat!(file)
    type == :regular and size <= max_size and size >= min_size
  end

  defp allowed_file_extension?(file, %{allowed_extensions: allowed, blocked_extensions: blocked}) do
    check_allow_and_block_list(file, allowed, blocked, &extension_in_map?/2)
  end

  defp allowed_path?(path, %{allowed_paths: allowed, blocked_paths: blocked}) do
    check_allow_and_block_list(path, allowed, blocked, &check_dir/2)
  end

  defp extension_in_map?(extensions_map, file) do
    extension =
      file
      |> String.split(".")
      |> Enum.reverse()
      |> Enum.at(0)

    MapSet.member?(extensions_map, extension)
  end

  defp check_dir(dir_map, dir) do
    Enum.any?(dir_map, &String.contains?(dir, &1))
  end

  defp check_allow_and_block_list(item, allow_list, block_list, function) do
    cond do
      MapSet.size(allow_list) > 0 ->
        function.(allow_list, item)

      MapSet.size(block_list) > 0 ->
        !function.(block_list, item)

      true ->
        true
    end
  end
end
