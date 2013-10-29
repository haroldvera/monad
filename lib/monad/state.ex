defmodule Monad.State do
  use Monad.Behaviour

  @moduledoc """
  The State monad.

  Allows keeping state "under the hood".

  ## Examples

      iex> use Monad
      iex> alias Monad.State
      iex> require State
      iex> s = State.m do
      ...>       a <- get
      ...>       put (a + 1)
      ...>       return a + 10
      ...>     end
      iex> State.run(2, s)
      {12, 3}
  """

  # A state monad is just a function that receives the "under the hood" state
  # value and returns a new state.
  @type state :: any
  @opaque state_m :: ((state) -> {any, state})

  ## Monad implementations

  @spec bind(state_m, ((any) -> state_m)) :: state_m
  def bind(s, f) do
    fn st ->
      {x, st1} = s.(st)
      f.(x).(st1)
    end
  end

  @spec return(any) :: state_m
  def return(x), do: fn st -> {x, st} end

  ## Other functions

  @doc """
  Run the state by supplying the given value to it and returning the return
  value of the monad and the final state.
  """
  @spec run(any, state) :: {any, state}
  def run(x, r), do: r.(x)

  @doc """
  Get the state.
  """
  @spec get() :: state_m
  def get(), do: fn st -> {st, st} end

  @doc """
  Set the new state.

  Returns `nil`.
  """
  @spec put(state) :: state_m
  def put(st), do: fn _ -> {nil, st} end

  @doc """
  Modify the state.

  Returns `nil`.
  """
  @spec modify(((state) -> state)) :: state_m
  def modify(f), do: fn st -> {nil, f.(st)} end
end
