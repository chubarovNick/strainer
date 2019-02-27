defmodule Strainer.DSL do
  defmacro __using__(_) do
    quote do
      import Ecto.Query
      import Strainer.DSL
      import Strainer.Conditions
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
