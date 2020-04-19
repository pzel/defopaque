defmodule EmailOpen do
  use Defopaque
  defopen(:email, String.t())

  @spec new(String.t()) :: t()
  def new(s) when is_binary(s) do
    email(s)
  end

end

defmodule EmailClosed do
  use Defopaque
  defopaque(:email, String.t())

  @spec new(String.t()) :: t()
  def new(s) when is_binary(s) do
    email(s)
  end
end

defmodule ExercisedFunctionality do
  require EmailClosed
  def f(s) do
    case EmailClosed.new(s) do
      e -> IO.inspect(e); "OK-closed"
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
