defmodule TypoKillerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @file_with_typo "./test/fixtures/file_with_typo.txt"
  @file_with_typo_output File.read!("./test/fixtures/file_with_typo_output.txt")

  describe "find_typos/2" do
    test "loads path correctly" do
      find_typos = fn ->
        TypoKiller.find_typos(@file_with_typo)
      end

      assert capture_io(find_typos) == @file_with_typo_output
    end
  end
end
