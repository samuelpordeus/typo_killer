defmodule TypoKiller.Dictionary do
  @moduledoc """
  Load a list of words and manage dictionary
  """
  @ignored_words_list "./priv/ignored_words.txt"
                      |> File.read!()
                      |> String.split("\n")

  @ignored_words_mapset MapSet.new(@ignored_words_list)

  @dialyzer {:nowarn_function, create: 1}

  @doc """
  Creates a dictionary from loaded English words and compare with typos
  and generate a tuple with different words and the dictionary
  """
  @spec create(words :: MapSet.t()) :: {MapSet.t(), MapSet.t()}
  def create(words)

  def create(%MapSet{} = words) do
    dictionary = MapSet.union(words, @ignored_words_mapset)
    words = MapSet.difference(words, @ignored_words_mapset)

    {words, dictionary}
  end
end
