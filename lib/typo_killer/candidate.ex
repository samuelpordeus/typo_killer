defmodule TypoKiller.Candidate do
  @moduledoc """
  Struct for a typo candidate
  """
  defstruct [:word, :similar_word, :score, :occurrences]

  @type t :: %__MODULE__{
          word: String.t(),
          similar_word: String.t(),
          score: number,
          occurrences: [{String.t(), [non_neg_integer]}]
        }
end
