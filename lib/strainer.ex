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
        __MODULE__
        |> Default.apply_filters(query, filters)
        |> group_by_primary_keys()
      end

      def filtered(query, filters, adapter) do
        adapter
        |> apply(:apply_filters, [__MODULE__, query, filters])
        |> group_by_primary_keys()
      end

      defp group_by_primary_keys(filtered) do
        schema = __MODULE__.schema()
        primary_keys = schema.__schema__(:primary_key)

        from(q in filtered,
          group_by: ^primary_keys
        )
      end
    end
  end
end
