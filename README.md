# Defopaque

An experiment in defining 'newtypes' in Elixir.

Read the [introduction
here](https://pzel.name/2020/04/26/Newtype-like-tagged-tuples-in-Elixir.html).

```
# file: mix.exs
defp deps do
  [
    {:defopaque, git: "https://github.com/pzel/defopaque.git", tag: "master"}
  ]
end

```

# 5-minute HOWTO

``` elixir
defmodule MMM do
  use Defopaque # load up the `defopaque/2` and `defopen/2` marcos

  # Generate a `valid_email(string)`
  # 1. type definition
  # 2. constructor macro, and (by extension)
  # 3. pattern-match marco
  defopen(:valid_email, String.t())

  # Generate a `token(number)` opaque type.
  # A constructor will be genereted, but
  # it will only be available in this module.
  defopaque(:token, number())


  def new_token(), do: token(System.unique_integer())

  def email_from_string(s) do
    # if string is legitimate valid email address, then:
    valid_email(s)
  end

  # we can pattern-match on `token/1` here, as it is 'our' opaque type
  def admission_pass(token(n), valid_email(s)) do
    %{seat_number: n, email_address: s}
  end
end


iex()> import MMM
iex()> input = "hello@example.com"

iex()>
case MMM.email_from_string(input) do
  valid_email(^input) -> {:ok, "your email was accepted"}
  _ -> {:error, "Invalid email"}
end
{:ok, "your email was accepted"}

iex()> t = MMM.new_token()
iex()> token(^number) = t
** (CompileError) iex:18: undefined function token/1

iex()> MMM.admission_pass(t, valid_email(input))
%{email_address: "hello@example.com", seat_number: -576460752303422719}
iex()> MMM.admission_pass({:token, 123}, valid_email(input))
** (FunctionClauseError) no function clause matching in MMM.admission_pass/2

    The following arguments were given to MMM.admission_pass/2:

        # 1
        {:token, 123}

        # 2
        {:"d237c68fd9b493a61d02bf9e-valid_email", "hello@example.com"}

    iex:42: MMM.admission_pass/2
```
