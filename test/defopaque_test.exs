defmodule DefopaqueTest do
  use ExUnit.Case
  doctest Defopaque

  test "it creates opaque struct" do
    defmodule M do
      use Defopaque
      defopaque(:email, String.t())

      # @spec f(String.t()) :: t()
      def f(s) do
        email(s)
      end

    end
    assert {kons, "hello"} = M.f("hello")
    assert kons == ""

  end
end
