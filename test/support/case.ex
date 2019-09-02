defmodule Strainer.TestCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      import Ecto
      import Strainer.TestCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Strainer.Repo)

    unless tags[:async] do
      Sandbox.mode(Strainer.Repo, {:shared, self()})
    end

    :ok
  end
end
