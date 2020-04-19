_doc = """
This module is just here to test
1) marco compilation
2) dialyzer error messages
"""

defmodule EmailOpen do
  use Defopaque
  defopen(:email, String.t())

  @spec new(String.t()) :: email()
  def new(s) when is_binary(s) do
    email(s)
  end

  # uncommenting this will give a dialyzer warning
  #
  # @spec badlyspecced(String.t()) :: String.t()
  # def badlyspecced(s) when is_binary(s) do
  #   email(s)
  # end
  # lib/exercised.ex:16: Invalid type specification for function 'Elixir.EmailOpen':badlyspecced/1. The success typing is
  # (binary()) -> {'b47a5143f8e79e299425-email', binary()}

end

defmodule EmailClosed do
  use Defopaque
  defopaque(:email, String.t())

  @spec new(String.t()) :: email()
  def new(s) when is_binary(s) do
    email(s)
  end
end

defmodule ExercisedFunctionality do
  require EmailClosed
  @spec f(String.t()) :: EmailClosed.email()
  def f(s) do
    case EmailClosed.new(s) do
      e -> IO.inspect(e)
    end
  end
end

defmodule ExercisedFunctionality2 do
  require EmailOpen
  def f(s) do
    case EmailOpen.new(s) do
      EmailOpen.email(^s) = e -> IO.inspect(e); "OK-open"
      _ -> "NOT OK"
    end
  end
end

defmodule ExercisedFunctionality3 do
  import EmailOpen
  def f(s) do
    case new(s) do
      email(^s) = e -> IO.inspect(e); "OK-open"
      _ -> "NOT OK"
    end
  end
end
