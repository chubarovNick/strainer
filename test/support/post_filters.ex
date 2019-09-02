defmodule Strainer.PostFilters do
  @moduledoc false
  use Strainer, schema: Strainer.Post

  # keyword shortcut

  filter_by([:title])
  filter_by(:tag_title_shorrtcut, {:tags, :title})
  # Custom extend query and apply condition function
  filter_by(:tag_title) do
    extend_query(&join_tags/1)

    apply_condition(fn c ->
      condition(:title, c)
    end)
  end

  filter_by(:tag_popularity) do
    extend_query(&join_tags/1)

    apply_condition(fn c ->
      condition(:popularity, c)
    end)
  end

  defp join_tags(query) do
    from(
      p in query,
      left_join: tags in assoc(p, :tags)
    )
  end
end
