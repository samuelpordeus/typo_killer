defmodule TypoKiller.FilesTest do
  use ExUnit.Case

  @base_path "./test/tmp"

  alias TypoKiller.Files

  describe "find_files_on_folder/1" do
    setup do
      File.mkdir_p!(@base_path)

      on_exit(fn ->
        File.rm_rf!(@base_path)
      end)

      files = [
        "potato/sample.txt",
        "potato/doc.md",
        "potato/is/good.bin",
        "potato/is/.amazing",
        "potato/with/fries/"
      ]

      {:ok, %{files: files}}
    end

    test "find all files inside a folder recursively, ignoring dot files", %{files: files} do
      expected =
        [
          "potato/doc.md",
          "potato/is/good.bin",
          "potato/sample.txt"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato")

      assert files == expected
    end

    test "find all files inside a folder recursively including dot files", %{files: files} do
      expected =
        [
          "potato/doc.md",
          "potato/is/good.bin",
          "potato/is/.amazing",
          "potato/sample.txt"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato", ignore_dot_files: false)

      assert files == expected
    end

    test "find all .txt files inside a folder recursively with allowed_extensions, ignoring dot files",
         %{files: files} do
      expected =
        [
          "potato/sample.txt"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato", allowed_extensions: ["txt"])

      assert files == expected
    end

    test "find all files,except .txt, inside a folder recursively with blocked_extensions , ignoring dot files",
         %{files: files} do
      expected =
        [
          "potato/doc.md",
          "potato/is/good.bin"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato", blocked_extensions: ["txt"])

      assert files == expected
    end

    test "find all files inside allowed paths, ignoring dot files", %{files: files} do
      expected =
        [
          "potato/is/good.bin"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato", allowed_paths: ["potato/is"])

      assert files == expected
    end

    test "find all files outside blocked paths, ignoring dot files", %{files: files} do
      expected =
        [
          "potato/doc.md",
          "potato/sample.txt"
        ]
        |> prepend_base_path()

      create_files(files)

      files = Files.find_files_on_folder(@base_path <> "/potato", blocked_paths: ["potato/is"])

      assert files == expected
    end

    test "find all files under 2kb, ignoring dot files" do
      path = @base_path <> "/potato"
      smaller_file = path <> "/smaller_file.txt"
      bigger_file = path <> "/bigger_file.txt"

      File.mkdir_p!(path)
      File.write!(smaller_file, random_data(1024))
      File.write!(bigger_file, random_data(1024 * 3))

      files = Files.find_files_on_folder(@base_path <> "/potato", max_size: 1024 * 2)

      assert files == [smaller_file]
    end
  end

  defp random_data(size_in_bytes, acc \\ <<>>)
  defp random_data(0, acc), do: acc

  defp random_data(size_in_bytes, acc) do
    new_acc = <<Enum.random(0..255)::size(8)>> <> acc
    random_data(size_in_bytes - 1, new_acc)
  end

  defp prepend_base_path(files) do
    Enum.map(files, fn file ->
      @base_path <> "/" <> file
    end)
  end

  defp create_files(files) do
    Enum.each(files, fn file ->
      path = @base_path <> "/" <> file
      [name | dir] = String.split(path, "/") |> Enum.reverse()
      dir = Enum.reverse(dir) |> Enum.join("/")

      File.mkdir_p!(dir)

      if name != "", do: File.touch!(path)
    end)
  end
end
