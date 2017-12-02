defmodule Exiota.Utils.InputValidator do
  @moduledoc """
  Helpers to validate inputs for addresses, trytes, etc.
  """

  @simple_tryte_regex ~r/^[9A-Z]/

  @doc """
  Checks if input is correct address
  """
  @spec address?(String.t) :: boolean()
  def address?(address) do
    cond do
      String.length(address) == 90 ->
        trytes?(address, 90)
      true ->
        trytes?(address, 81)
    end
  end

  @doc """
  Checks if input is correct trytes consisting of A-Z9

  Optionally validate length
  """
  @spec trytes?(String.t, Integer.t) :: boolean()
  def trytes?(trytes, length \\ nil)
  def trytes?("", _), do: false
  def trytes?(trytes, nil) do
    case Regex.run(@simple_tryte_regex, trytes) do
      [trytes] ->
        true
      _ ->
        false
    end
  end
  def trytes?(trytes, length) when is_integer(length) do
    exp = Regex.compile!("^[9A-Z]{#{length}}")
    case Regex.run(exp, trytes) do
      [trytes] ->
        true
      _ ->
        false
    end
  end

  @doc """
  Checks for a nine tryte
  """
  def nine_trytes?(trytes) when is_binary(trytes), do:
    Regex.match?(~r/^[9]+/, trytes)
  def nine_trytes?(_), do: false

  @doc """
  Checks if value is integer
  """
  def value?(value), do: is_integer(value)

  @doc """
  Checks whether input is a value or not. Can be a string, float or integer
  """
  def num?(input), do: Regex.match?(~r/^(\d+\.?\d{0,15}|\.\d{0,15})/, input)

  def hash?(input), do: trytes?(input, 81)
end
