defmodule Strainer do
  @moduledoc """
  Documentation for Strainer.
  """
  defmacro __using__(schema: schema) do
    quote do
      use Strainer.DSL

      def filtered(query, filters) do
        filters
        |> Enum.reduce(query, &apply_filter/2)
      end

      defp apply_filter({key, value}, query) do
        schema_module = unquote(schema)
        module_fields = schema_module.__schema__(:fields)

        cond do
          key in module_fields ->
            filter_schema_field(key, query, %{eq: value})

          true ->
            apply(__MODULE__, :filter, [key, query, %{eq: value}])
        end
      end

      defp filter_schema_field(key, query, condition) do
        query
        |> where(^condition(key, condition))
      end
    end
  end
end
