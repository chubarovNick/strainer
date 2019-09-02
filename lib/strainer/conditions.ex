defmodule Strainer.Conditions do
  @moduledoc """
  Conditions functions for build query
  """
  import Ecto.Query

  def self_condition(column, %{eq: value}) do
    dynamic([query], field(query, ^column) == ^value)
  end

  def self_condition(column, %{ne: value}) do
    dynamic([query], field(query, ^column) != ^value)
  end

  def self_condition(column, %{lt: value}) do
    dynamic([query], field(query, ^column) < ^value)
  end

  def self_condition(column, %{lte: value}) do
    dynamic([query], field(query, ^column) <= ^value)
  end

  def self_condition(column, %{gte: value}) do
    dynamic([query], field(query, ^column) >= ^value)
  end

  def self_condition(column, %{gt: value}) do
    dynamic([query], field(query, ^column) > ^value)
  end

  def self_condition(column, %{null: false}) do
    dynamic([query], not is_nil(field(query, ^column)))
  end

  def self_condition(column, %{null: true}) do
    dynamic([query], is_nil(field(query, ^column)))
  end

  def self_condition(column, %{not_between: values}) do
    [left_value, right_value] = values

    dynamic(
      [q],
      not (field(q, ^column) >= ^left_value and ^right_value <= field(q, ^column))
    )
  end

  def self_condition(column, %{between: values}) do
    [left_value, right_value] = values
    dynamic([q], field(q, ^column) >= ^left_value and ^right_value <= field(q, ^column))
  end

  def self_condition(column, %{in: values}) do
    dynamic([query], field(query, ^column) in ^values)
  end

  def self_condition(column, %{not_like: value}) do
    dynamic([query], not ilike(field(query, ^column), ^value))
  end

  def self_condition(column, %{ilike: value}) do
    dynamic([query], ilike(field(query, ^column), ^value))
  end

  def self_condition(column, %{contains: values}) do
    dynamic([query], fragment("? @> ?", field(query, ^column), ^values))
  end

  def self_condition(column, %{not_contains: values}) do
    dynamic([..., query], not fragment("? @> ?", field(query, ^column), ^values))
  end

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
    dynamic([..., query], not ilike(field(query, ^column), ^value))
  end

  def condition(column, %{ilike: value}) do
    dynamic([..., query], ilike(field(query, ^column), ^value))
  end

  def condition(column, %{contains: values}) do
    dynamic([..., query], fragment("? @> ?", field(query, ^column), ^values))
  end

  def condition(column, %{not_contains: values}) do
    dynamic([..., query], not fragment("? @> ?", field(query, ^column), ^values))
  end

end
