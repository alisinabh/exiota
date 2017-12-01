defmodule Exiota.Trinary do
  @moduledoc """

  """

  defstruct [trits: nil]

  @tryte_to_trits_mappings Application.get_env(:exiota, :tryte_to_tetris_mappings)

  def get_trits(trits = [_, _, _, _, _, _, _, _]), do:
    %__MODULE__{trits: trits}

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
  def valid?([trit | t]) when trit <= 1 and trit >= -1, do: valid?(t)
  def valid?([]), do: true
  def valid?([_ | _t]), do: false


  @doc """
  Converts a signed little endian int64 to trits
  """
  def int_to_trits(num) when is_integer(num), do:
    int_to_trits(<<num::little-signed-64>>, num < 0)

  def int_to_trits(trits = <<_::binary-8>>, false), do:
    {:ok, %__MODULE__{trits: trits}}

  def int_to_trits(<<t1, t2, t3, t4, t5, t6, t7, t8>>, true), do:
    {:ok, %__MODULE__{trits: <<-t1, -t2, -t3, -t4, -t5, -t6, -t7, -t8>>}}

  @doc """
  Converts trits to int
  """
  def trits_to_int(%__MODULE__{trits: <<trits::little-signed-64>>}), do:
    {:ok, trits}

end
