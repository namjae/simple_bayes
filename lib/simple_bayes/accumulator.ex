defmodule SimpleBayes.Accumulator do
  @doc """
  Accumulates the values from the map.

  ## Examples

      iex> SimpleBayes.Accumulator.all(%{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2})
      7

      iex> SimpleBayes.Accumulator.all(%{"nice" => 3.5, "cute" => 1, "cat" => 1, "dog" => 2.2})
      7.7

      iex> SimpleBayes.Accumulator.all(%{})
      1
  """
  def all(map) when map == %{}, do: 1
  def all(map) do
    map |> Map.values() |> Enum.reduce(&(&1+&2))
  end

  @doc """
  Accumulates the values of the given keys from the map.

  ## Examples

      iex> SimpleBayes.Accumulator.only(%{"nice" => 3, "cute" => 1, "cat" => 1, "dog" => 2}, ["nice", "cute"])
      4

      iex> SimpleBayes.Accumulator.only(%{"nice" => 3.5, "cute" => 1, "cat" => 1, "dog" => 2.2}, ["nice", "cute"])
      4.5
  """
  def only(map, keys) do
    map |> Map.take(keys) |> all()
  end

  @doc """
  Accumulates the number of maps containing the specified key.

  ## Examples

      iex> SimpleBayes.Accumulator.occurance(%{
      iex>   {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}} => nil,
      iex>   {:dog, %{"nice" => 2, "dog" => 2}} => nil
      iex> }, "cute")
      1

      iex> SimpleBayes.Accumulator.occurance(%{
      iex>   {:cat, %{"nice" => 1, "cute" => 1, "cat" => 1}} => nil,
      iex>   {:dog, %{"nice" => 2, "dog" => 2}} => nil
      iex> }, "nice")
      2
  """
  def occurance(meta_map, key) do
    Enum.reduce(meta_map, 0, fn ({{_, map}, _}, acc) ->
      if Map.has_key?(map, key), do: acc + 1, else: acc
    end)
  end
end
