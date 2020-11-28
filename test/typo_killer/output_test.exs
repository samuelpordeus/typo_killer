defmodule TypoKiller.OutputTest do
  use TypoKiller.Case

  alias TypoKiller.Candidate
  alias TypoKiller.Output

  describe "print_candidates/1" do
    test "should print middle" do
      file = "./test/fixtures/output.txt"

      candidates = [
        %Candidate{
          occurrences: [
            {file, [1, 2]},
            {file, [2, 3]}
          ],
          similar_word: nil,
          score: nil,
          word: "mnigrations"
        }
      ]

      io_write = fn ->
        Output.print_candidates(candidates)
      end

      assert capture_io(io_write) == build_output(candidates)
    end
  end

  defp build_output(candidates) when is_list(candidates) do
    output =
      Enum.map(candidates, fn candidate = %Candidate{} ->
        {[], occurrences} =
          Enum.reduce(candidate.occurrences, {candidate.occurrences, []}, fn _occ,
                                                                             {acc, occurrences} ->
            occurrences = occurrences ++ [build_occurrences(acc)]
            [_ | acc] = acc
            {acc, occurrences}
          end)

        """
        ┌ #{candidate.word}
        ├──┬─ Similar to: #{candidate.similar_word}
        │  └─ Score: #{candidate.score}
        │
        """ <> Enum.join(occurrences)
      end)

    Enum.join(output, "\n") <> "\n"
  end

  defp build_occurrences([{path, lines}]) do
    """
    │
    └──┬─ File: #{path}
       └─ Lines: #{Enum.join(lines, ", ")}
    """
  end

  defp build_occurrences([{path, lines} | _remaining]) do
    """
    ├──┬─ File: #{path}
    │  └─ Lines: #{Enum.join(lines, ", ")}
    """
  end
end
