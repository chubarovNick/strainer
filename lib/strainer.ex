defmodule Strainer do
  @moduledoc """
  Documentation for Strainer.
  """
  defmacro __using__(schema: schema) do
    quote do
      use Strainer.DSL
      alias Strainer.Adapters.Default

      Module.register_attribute(__MODULE__, :schema, accumulate: false)
      Module.put_attribute(__MODULE__, :schema, unquote(schema))

      def schema, do: unquote(schema)

      def filtered(query, filters) do
        Default.apply_filters(__MODULE__, query, filters)
      end
    end
  end
end
