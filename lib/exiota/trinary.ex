defmodule Exiota.Trinary do
  @moduledoc """
  Helpers for working with trits and trytes
  """

  @tryte_to_trits_mappings Application.get_env(:exiota, :tryte_to_tetris_mappings)

  @doc """
  Checks if a trit is valid or not.

  ## Examples
      iex> Exiota.Trinary.valid_trit?(1)
      true

      iex> Exiota.Trinary.valid_trit?(-1)
      true

      iex> Exiota.Trinary.valid_trit?(1.001)
      false

      iex> Exiota.Trinary.valid_trit?(-2)
      false
  """
  @spec valid_trit?(Integer.t) :: boolean()
  def valid_trit?(t) when t <= 1 and t >= -1, do: true
  def valid_trit?(_), do: false

  @doc """
  Checks if a trit set is valid or not

  ## Examples
      iex> Exiota.Trinary.valid?([1, -1, 0.5, -0.999, 0.9999])
      true

      iex> Exiota.Trinary.valid?([1, 1.001, -1])
      false
  """
  def valid?([]), do: false
  def valid?(trits) when is_list(trits), do: do_valid?(trits)
  def valid?(_), do: false

  defp do_valid?([trit | t]) when trit <= 1 and trit >= -1, do: do_valid?(t)
  defp do_valid?([]), do: true
  defp do_valid?(_), do: false

  @doc """
  Determines if two trits are equal

  ## Examples
      iex> Exiota.Trinary.equal?([1, 2, 3], [1, 2, 3])
      true

      iex> Exiota.Trinary.equal?([1, 3, 2], [1, 2, 3])
      false
  """
  def equal?(trit_a, trit_b) when is_list(trit_a) and is_list(trit_b), do:
    trit_a == trit_b
  def equal?(_, _), do: false

  @doc """
  Converts a signed little endian int64 to trits
  """
  # TODO: add size and make dynamic
  def int_to_trits(num) when is_integer(num), do:
    int_to_trits(<<num::little-signed-64>>, num < 0)

  def int_to_trits(<<t1, t2, t3, t4, t5, t6, t7, t8>>, false), do:
    {:ok, <<t1, t2, t3, t4, t5, t6, t7, t8>>}

  def int_to_trits(<<t1, t2, t3, t4, t5, t6, t7, t8>>, true), do:
    {:ok, <<-t1, -t2, -t3, -t4, -t5, -t6, -t7, -t8>>}

  def int_to_trits(_, _), do:
    {:error, :invalid_input}

  @doc """
  Converts trits to int
  """
  # TODO: Use list
  def trits_to_int(<<trits::little-signed-64>>), do:
    {:ok, trits}
  def trits_to_int(_), do:
    {:error, :invalid_trits}

  @doc """
  Determines if a trits binary can be converted to Trytes.
  The condition is the mod of trits length to 3 is zero.
  (trits length are dividalbe by 3)
  """
  # TODO: Use list
  def can_tryte?(trits) when is_binary(trits), do:
    rem(byte_size(trits), 3) == 0
end
