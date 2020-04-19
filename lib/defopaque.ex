defmodule Defopaque do
  defmacro __using__(_) do
    quote do
      import Defopaque
    end
  end

  defmacro defopaque(kons, typ) do
    t = build_cons(kons, typ)
    quote do
      @opaque unquote(kons)() :: {unquote(t), unquote(typ)}
      defmacrop unquote(kons)(arg) do
        opaque_kons = unquote(t)
        quote do: {unquote(opaque_kons), unquote(arg)}
      end
    end
  end

  defmacro defopen(kons, typ) do
    t = build_cons(kons, typ)
    quote do
      @type unquote(kons)() :: {unquote(t), unquote(typ)}
      defmacro unquote(kons)(arg) do
        opaque_kons = unquote(t)
        quote do: {unquote(opaque_kons), unquote(arg)}
      end
    end
  end

  defp build_cons(constructor, value_type) do
    c = String.trim(inspect(constructor), ":")
    b = c <> inspect(value_type)
    h = :crypto.hash(:sha256, b) |> String.slice(1..10)
    :"#{String.downcase(Base.encode16(h))}-#{c}"
  end

end
