defmodule ExiotaTest do
  use ExUnit.Case
  doctest Exiota
  doctest Exiota.Trinary

  test "greets the world" do
    assert Exiota.hello() == :world
  end
end
