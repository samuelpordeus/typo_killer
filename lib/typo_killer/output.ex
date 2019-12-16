defmodule TypoKiller.Output do
  @moduledoc """
  Functions to pretty print results
  """

  alias TypoKiller.Candidate

  @doc """
  Pretty print a list of candidates
  """
  @spec print_candidates([Candidate.t()]) :: :ok
  def print_candidates(candidates) do
    Enum.each(candidates, fn candidate ->
      """
      ┌ #{candidate.word}
      ├──┬─ Similar to: #{candidate.similar_word}
      │  └─ Score: #{candidate.score}
      │
      """
      |> IO.write()

      print(candidate.occurrences, &print_middle/1, &print_last/1)
    end)
  end

  defp print_middle({file, lines}) do
    """
    ├──┬─ File: #{file}
    │  └─ Lines: #{Enum.join(lines, ", ")}
    │
    """
    |> IO.write()
  end

  defp print_last({file, lines}) do
    """
    └──┬─ File: #{file}
       └─ Lines: #{Enum.join(lines, ", ")}
    """
    |> IO.puts()
  end

  defp print([last], _middle_fn, last_fn) do
    last_fn.(last)
  end

  defp print([element | remaining], middle_fn, last_fn) do
    middle_fn.(element)
    print(remaining, middle_fn, last_fn)
  end
end
