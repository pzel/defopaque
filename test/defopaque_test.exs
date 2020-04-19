defmodule DefopaqueTest do
  use ExUnit.Case
  doctest Defopaque

  test "it creates opaque struct" do
    defmodule M do
      use Defopaque
      defopaque(:email, String.t())
      def f(s), do: email(s)
    end

    assert {kons, "hello"} = M.f("hello")
    assert kons == :"2b5ee5717f7cd8908c0ddb850c-email"
  end

  defmodule Kg do
    use Defopaque
    defopen(:kg, number())
  end

  test "open struct can be used to pattern match" do
    import Kg
    tell_weight = fn(w) ->
      case w do
        kg(12) -> "twelve kilograms"
        kg(other) -> "#{other} kg"
        _ -> "invalid unit"
      end
    end
    assert tell_weight.(kg(12)) == "twelve kilograms"
    assert tell_weight.(kg(11)) == "11 kg"
    assert tell_weight.(11) == "invalid unit"
  end

  test "open struct can be used to hat-match" do
    import Kg
    want_value = 5
    weights = [kg(1), kg(3), kg(5), kg(10)]

    assert Enum.count(weights,
      fn kg(^want_value) -> true
        kg(_) -> false
      end) == 1
  end


end
