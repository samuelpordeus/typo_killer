defmodule TypoKiller.Typos do
  @moduledoc """
  Find typos
  """
  @minimum_jaro_distance 0.95
  @default_max_demand 100

  alias TypoKiller.Candidate

  @doc """
  Based on a list of words, search for possible typos by comparing them with an auxiliar dictionary
  """
  @spec find(
          {candidates :: [Candidate.t()], dictionary :: MapSet.t()},
          options :: Keyword.t()
        ) :: Map.t()
  def find({candidates, dictionary}, options \\ []) do
    max_demand = options[:max_demand] || @default_max_demand

    candidates
    |> Flow.from_enumerable(max_demand: max_demand)
    |> Flow.map(fn candidate -> calculate_distance(candidate, dictionary) end)
    |> Flow.reduce(fn -> [] end, &Kernel.++/2)
    |> Enum.filter(fn candidate -> candidate != nil end)
  end

  defp calculate_distance(%Candidate{word: word} = candidate, dict) do
    dict
    |> Enum.map(fn word_from_dict ->
      with jaro_distance <- String.jaro_distance(word, word_from_dict),
           true <- jaro_distance >= @minimum_jaro_distance and jaro_distance < 1.0 do
        %Candidate{candidate | similar_word: word_from_dict, score: jaro_distance}
      else
        _any -> nil
      end
    end)
  end
end
