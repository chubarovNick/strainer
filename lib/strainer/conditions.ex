defmodule Strainer.Conditions do
  import Ecto.Query

  def condition(column, %{eq: value}) do
    dynamic([..., query], field(query, ^column) == ^value)
  end

  def condition(column, %{ne: value}) do
    dynamic([..., query], field(query, ^column) != ^value)
  end

  def condition(column, %{lt: value}) do
    dynamic([..., query], field(query, ^column) < ^value)
  end

  def condition(column, %{lte: value}) do
    dynamic([..., query], field(query, ^column) <= ^value)
  end

  def condition(column, %{gte: value}) do
    dynamic([..., query], field(query, ^column) >= ^value)
  end

  def condition(column, %{gt: value}) do
    dynamic([..., query], field(query, ^column) > ^value)
  end

  def condition(column, %{null: false}) do
    dynamic([..., query], not is_nil(field(query, ^column)))
  end

  def condition(column, %{null: true}) do
    dynamic([..., query], is_nil(field(query, ^column)))
  end

  def condition(column, %{not_between: values}) do
    [left_value, right_value] = values

    dynamic(
      [..., q],
      not (field(q, ^column) >= ^left_value and ^right_value <= field(q, ^column))
    )
  end

  def condition(column, %{between: values}) do
    [left_value, right_value] = values
    dynamic([..., q], field(q, ^column) >= ^left_value and ^right_value <= field(q, ^column))
  end

  def condition(column, %{in: values}) do
    dynamic([..., query], field(query, ^column) in ^values)
  end

  def condition(column, %{not_like: value}) do
    match = like_statement(value)
    dynamic([..., query], not ilike(field(query, ^column), ^match))
  end

  def condition(column, %{ilike: value}) do
    match = like_statement(value)
    dynamic([..., query], ilike(field(query, ^column), ^match))
  end

  def condition(column, %{contains: values}) do
    dynamic([..., query], fragment("? @> ?", field(query, ^column), ^values))
  end

  def condition(column, %{not_contains: values}) do
    dynamic([..., query], not fragment("? @> ?", field(query, ^column), ^values))
  end

  defp like_statement(value) do
    "%#{value}%"
  end
end
