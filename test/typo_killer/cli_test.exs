defmodule TypoKiller.CLITest do
  use TypoKiller.Case, async: true

  alias TypoKiller.CLI

  @no_action_defined """
  Error: no action provided.

  Available actions: run

  """

  @avaliable_actions """
  Error: unknown action 'foobar'.

  Available: run

  """

  @help_action """
  TypoKiller - qu'est que ce
  ---------------------
  Usage:
    typokiller <command> <options>

  Available commands: run

  Options
    -p, --path <path>          Run TypoKiller in the given path

  Example:

    typokiller run --path ~/my_project


  """

  describe "main/0" do
    test "without action defined" do
      main = fn -> CLI.main() end

      assert capture_io(main) == @no_action_defined
    end
  end

  describe "main/1" do
    test "using help command" do
      main = fn -> CLI.main(["--help"]) end

      assert capture_io(main) == @help_action
    end

    test "using valid arguments" do
      main = fn -> CLI.main(["run", "-p", @file_with_typo]) end

      assert capture_io(main) == @file_with_typo_output
    end

    test "using invalid arguments" do
      invalid_arg = "-x"

      main = fn -> CLI.main(["run", invalid_arg, @file_with_typo]) end

      output = """
      Error -  invalid args:

      #{invalid_arg}

      """

      assert capture_io(main) == output
    end

    test "using unknown command" do
      main = fn -> CLI.main(["foobar"]) end

      assert capture_io(main) == @avaliable_actions
    end
  end
end
