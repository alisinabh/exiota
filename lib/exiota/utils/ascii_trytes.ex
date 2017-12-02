defmodule Exiota.Utils.AsciiTrytes do
  @moduledoc """
  This moduled helps with conversation between ascii and trytes
  """

  @tryte_values "9ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  @doc """
  Converts an input to trytes string

  ## Examples
      iex> Exiota.Utils.AsciiTrytes.to_trytes "Z"
      {:ok, "IC"}
  """
  @spec to_trytes(String.t) :: {:ok, String.t} | {:error, atom()}
  def to_trytes(input) do
    {:ok, do_to_trytes(input, "")}
  end

  @doc """
  Trytes to bytes

  ## Examples
      iex> Exiota.Utils.AsciiTrytes.from_trytes "IC"
      {:ok, "Z"}
  """
  @spec from_trytes(String.t) :: {:ok, String.t} | {:error, atom()}
  def from_trytes(input) do
    case rem(String.length(input), 2) do
      0 ->
        {:ok, do_from_trytes(input, "")}
      _ ->
        {:error, :odd_length_input}
    end
  end

  #
  # Helpers
  #

  # Making a pattern matching style dynamic position finder
  # This method helps with performance
  Enum.each(String.to_charlist(@tryte_values), fn t1 ->
    {t1_cur, _} = :binary.match(@tryte_values, <<t1::utf8>>)
    defp get_pos(unquote(t1)) do
      unquote(t1_cur)
    end
  end)

  defp get_char(pos) do
    String.at(@tryte_values, pos)
  end

  defp do_to_trytes(<<t, tail::binary>>, acc) do
    first_value = rem(t, 27)
    second_value = round((t - first_value) / 27)

    do_to_trytes(
      tail,
      (acc <> get_char(first_value) <> get_char(second_value))
    )
  end
  defp do_to_trytes("",  acc), do: acc

  defp do_from_trytes(<<t1, t2, tail::binary>>, acc) do
    val = get_pos(t1) + get_pos(t2) * 27
    do_from_trytes(tail, acc <> <<val::utf8>>)
  end
  defp do_from_trytes("", acc), do: acc
end
