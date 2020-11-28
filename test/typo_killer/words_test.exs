defmodule TypoKiller.WordsTest do
  use TypoKiller.Case

  alias TypoKiller.Words

  @files ~w(
    ./test/fixtures/words.txt
  )

  describe "files_to_words/1" do
    test "should merge file results" do
      assert {[%TypoKiller.Candidate{}, %TypoKiller.Candidate{}], _} =
               Words.files_to_words(@files)
    end
  end
end
