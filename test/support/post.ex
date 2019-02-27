defmodule Strainer.Post do
  @moduledoc false
  use Ecto.Schema

  schema "posts" do
    field(:title)
    many_to_many(:tags, Strainer.Tag, join_through: "posts_tags")
  end
end
