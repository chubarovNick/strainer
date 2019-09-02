defmodule Strainer.Adapters.Advanced do
  @moduledoc """
  Advanced adapter of arguments to query
  """
  import Ecto.Query

  # @clause [
  #   %{
  #     kind: :clauses, ?????
  #     inject_with: :and
  #     clauses: [
  #       %{
  #         kind: :clause, ????
  #         filter: :name,
  #         predicate: :eq,
  #         value: "name"
  #       }
  #     ]
  #   }
  # ]

  def apply_filters(filter_module, base_query, filters) do
    filters
    |> Enum.reduce(base_query, fn c, acc ->
      {q, clause} = process_clause(c, acc, filter_module)

      q
      |> where(^clause)
    end)
  end

  defp process_clause(%{kind: :clause} = c, query, filter_module) do
    extended_query = apply(filter_module, :query_extend, [c.filter, query])
    {extended_query, apply(filter_module, :get_condition, [c.filter, %{c.predicate => c.value}])}
  end

  defp process_clause(%{kind: :clauses} = c, query, filter_module) do
    start_clause =
      case c.inject_with do
        :and ->
          true

        :or ->
          false
      end

    c.clauses
    |> Enum.reduce({query, start_clause}, fn cx, {acc_q, acc_d} ->
      {q, d} = process_clause(cx, acc_q, filter_module)

      case c.inject_with do
        :and ->
          {q, dynamic([], ^acc_d and ^d)}

        :or ->
          {q, dynamic([], ^acc_d or ^d)}
      end
    end)
  end
end
