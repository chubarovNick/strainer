defmodule Strainer.Tag do
  @moduledoc false
  use Ecto.Schema

  schema "tags" do
    field(:title)
    field(:popularity, :integer)
    many_to_many(:posts, Strainer.Post, join_through: "posts_tags")
  end
end
