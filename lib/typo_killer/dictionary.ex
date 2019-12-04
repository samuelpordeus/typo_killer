defmodule TypoKiller.Dictionary do
  @moduledoc """
  Load a list of words and manage dictionary
  """
  @ignored_words_list "./priv/ignored_words.txt"
                      |> File.read!()
                      |> String.split("\n")

  @ignored_words_mapset MapSet.new(@ignored_words_list)

  @doc """
  Creates a dictionary from loaded English words and compare with typos
  and generate a tuple with different words and the dictionary
  """
  @spec create(words :: MapSet.t) :: {MapSet.t, MapSet.t}
  def create(words)

  def create(%MapSet{} = words) do
    dictionary = MapSet.union(words, @ignored_words_mapset)
    words = MapSet.difference(words, @ignored_words_mapset)

    {words, dictionary}
  end

  def aux_dictionary, do: @ignored_words_list

  def remove_ignored_words(words) do
    words
    |> MapSet.new()
    |> MapSet.difference(@ignored_words_mapset)
    |> MapSet.to_list()
  end
end
