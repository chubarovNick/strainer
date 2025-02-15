defmodule Strainer.DSL do
  @moduledoc """
  Provide dsl for filters module
  """
  import Strainer.Conditions

  defmacro __using__(_) do
    quote do
      import Ecto.Query
      import Strainer.DSL
      import Strainer.Conditions
    end
  end

  defmacro extend_query(function) do
    function_body = Macro.escape(function)

    quote bind_quoted: [f_body: function_body] do
      [key | _] = @key

      def unquote(:query_extend)(key, query) when key == unquote(key) do
        unquote(f_body).(query)
      end
    end
  end

  defmacro apply_condition(function) do
    function_body = Macro.escape(function)

    quote bind_quoted: [f_body: function_body] do
      [key | _] = @key

      def unquote(:get_condition)(key, condition) when key == unquote(key) do
        unquote(f_body).(condition)
      end
    end
  end

  defmacro filter_by(keys) when is_list(keys) do
    quote bind_quoted: [keys: Macro.escape(keys)] do
      def unquote(:query_extend)(key, query) when key in unquote(keys) do
        query
      end

      def unquote(:get_condition)(key, condition) when key in unquote(keys) do
        self_condition(key, condition)
      end
    end
  end

  defmacro filter_by(key, do: block) do
    quote do
      Module.register_attribute(__MODULE__, :key, accumulate: true)
      Module.put_attribute(__MODULE__, :key, unquote(key))
      unquote(block)
    end
  end

  defmacro filter_by(key, {assoc, field}) do
    quote do
      Module.register_attribute(__MODULE__, :key, accumulate: true)
      Module.put_attribute(__MODULE__, :key, unquote(key))

      extend_query(fn query ->
        from(
          p in query,
          left_join: tags in assoc(p, ^unquote(assoc))
        )
      end)

      apply_condition(fn c ->
        condition(unquote(field), c)
      end)
    end
  end

  defmacro filter_by(key, function) do
    function_body = Macro.escape(function)
    escaped_key = Macro.escape(key)

    quote bind_quoted: [f_body: function_body, escaped_key: escaped_key] do
      def unquote(:filter)(key, query, condition) when key == unquote(escaped_key) do
        query
        |> unquote(f_body).(condition)
      end
    end
  end
end
