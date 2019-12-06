defmodule TypoKiller.CLI do
  @cli_options [
    allow_nonexistent_atoms: false,
    strict: [
      path: :string,
      help: :boolean
    ],
    aliases: [
      p: :path,
      h: :help
    ]
  ]

  @available_cmds ["run"]

  def main(argv \\ []) do
    argv
    |> OptionParser.parse(@cli_options)
    |> launch()
  end

  defp launch({options, command, []}) do
    cond do
      options[:help] ->
        print_help()

      true ->
        do_launch(command, options)
    end
  end

  defp launch({_options, _command, invalid_args}) do
    cmd_str =
      invalid_args
      |> Enum.map(fn {opt, _} -> opt end)
      |> Enum.join("\n")

    """
    Error -  invalid args:

    #{cmd_str}
    """
    |> IO.puts()
  end

  defp do_launch(["run"], options) do
    path = options[:path] || "."

    TypoKiller.find_typos(path)
  end

  defp do_launch([], _options) do
    """
    Error: no action provided.

    Available actions: #{Enum.join(@available_cmds, ", ")}
    """
    |> IO.puts()
  end

  defp do_launch(command, _options) do
    """
    Error: unknown action '#{command}'.

    Available: #{Enum.join(@available_cmds, ", ")}
    """
    |> IO.puts()
  end

  defp print_help do
    """
    TypoKiller - qu'est que ce
    ---------------------
    Usage:
      typokiller <command> <options>

    Available commands: #{Enum.join(@available_cmds, ", ")}

    Options
      -p, --path <path>          Run TypoKiller in the given path

    Example:

      detektive run --path ~/my_project

    """
    |> IO.puts()
  end
end
