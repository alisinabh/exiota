defmodule ExiotaTest do
  use ExUnit.Case
  doctest Exiota
  doctest Exiota.Utils.AsciiTrytes

  test "greets the world" do
    assert Exiota.hello() == :world
  end
end
