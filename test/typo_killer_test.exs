defmodule TypoKillerTest do
  use TypoKiller.Case, async: true

  describe "find_typos/2" do
    test "find typos and print them" do
      find_typos = fn ->
        TypoKiller.find_typos(@file_with_typo)
      end

      assert capture_io(find_typos) == @file_with_typo_output
    end

    test "find typos using options and print them" do
      options = [ignore_dot_files: false]

      find_typos = fn ->
        TypoKiller.find_typos(@file_with_typo, options)
      end

      assert capture_io(find_typos) ==
               format_options(@file_with_typo_output_using_options, options)
    end

    test "find typos using options with array values and print them" do
      options = [allowed_extensions: [".ex", ".exs"]]

      find_typos = fn ->
        TypoKiller.find_typos(@file_with_typo, options)
      end

      output = """
      Path: "./test/fixtures/file_with_typo.txt\"
      Options:
      {{options}}
      ---
      Running...
      """

      assert capture_io(find_typos) == format_options(output, options)
    end
  end

  describe "benchmark_find_typos/1" do
    test "generate benchmark for given path" do
      find_typos = fn ->
        TypoKiller.benchmark_find_typos(@file_with_typo)
      end

      assert String.contains?(capture_io(find_typos), @file_with_typo_output)
    end
  end

  defp format_options(output, options) do
    options =
      Enum.map(options, fn
        {k, v} when is_list(v) ->
          "  #{Atom.to_string(k)} -> #{Enum.join(v, ", ")}"

        {k, v} ->
          "  #{Atom.to_string(k)} -> #{inspect(v)}"
      end)

    String.replace(output, "{{options}}", Enum.join(options, "\n"))
  end
end
