defmodule Mix.Tasks.TypoKillerTest do
  use TypoKiller.Case, async: true

  alias Mix.Tasks.TypoKiller

  describe "run/1" do
    test "should find typos from given directory" do
      find_typos = fn ->
        TypoKiller.run([@file_with_typo])
      end

      assert capture_io(find_typos) == @file_with_typo_output
    end
  end
end
