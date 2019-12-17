defmodule TypoKiller.TyposTest do
  use ExUnit.Case, async: true

  alias TypoKiller.Candidate
  alias TypoKiller.Typos

  describe "find/2" do
    test "find a typo successfully" do
      words = MapSet.new(["successfull"])
      words_to_be_ignored = MapSet.new(["successful"])

      dictionary = MapSet.union(words, words_to_be_ignored)

      candidates =
        Enum.map(words, fn word ->
          %Candidate{
            word: word,
            occurrences: Map.get(%{"successfull" => 1}, word)
          }
        end)

      candidates = Typos.find({candidates, dictionary})

      assert candidates == [
               %TypoKiller.Candidate{
                 occurrences: 1,
                 score: 0.9696969696969697,
                 similar_word: "successful",
                 word: "successfull"
               }
             ]
    end
  end
end
