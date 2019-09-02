defmodule Strainer.Adapters.Default do
  @moduledoc """
  Default adapter of arguments to query
  """
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

    if key in module_fields do
      filter_schema_field(key, query, value)
    else
      extended_query = apply(filter_module, :query_extend, [key, query])

      extended_query
      |> where(^apply(filter_module, :get_condition, [key, %{eq: value}]))
    end
  end

  defp filter_schema_field(key, query, condition) do
    query
    |> where([q], ^self_condition(key, %{eq: condition}))
  end
end
