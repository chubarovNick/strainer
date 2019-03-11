defmodule Strainer.Adapters.Default do
  import Ecto.Query
  import Strainer.Conditions

  def apply_filters(filter_module, base_query, filters) do
    filters
    |> Enum.reduce(base_query, fn item, query ->
      query
      |> apply_filter(item, filter_module)
    end)
  end

  defp apply_filter(query, {key, value}, filter_module) do
    schema_module = filter_module.schema()
    module_fields = schema_module.__schema__(:fields)

    cond do
      key in module_fields ->
        filter_schema_field(key, query, %{eq: value})

      true ->
        extended_query = apply(filter_module, :query_extend, [key, query])

        extended_query
        |> where(^apply(filter_module, :get_condition, [key, %{eq: value}]))
    end
  end

  defp filter_schema_field(key, query, condition) do
    query
    |> where(^condition(key, condition))
  end
end
