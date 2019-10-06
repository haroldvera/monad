defmodule Monad.List do
  use Monad
  use Monad.Pipeline

  def return(x), do: [x]
  def bind(x, f), do: Enum.flat_map(x, f)
end
