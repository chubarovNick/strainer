defmodule Strainer.PostFilters do
  use Strainer, schema: Strainer.Post

  filter_by(:tag_title, fn query, %{eq: value} ->
    from(
      p in query,
      left_join: tags in assoc(p, :tags),
      where: tags.title == ^value
    )
  end)
end
