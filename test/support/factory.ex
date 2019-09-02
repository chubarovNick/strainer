defmodule Strainer.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Strainer.Repo

  alias Strainer.{Post, Tag}

  @spec post_factory() :: Strainer.Post.t()
  def post_factory do
    %Post{
      title: sequence(:title, &"Post Title #{&1}")
    }
  end

  @spec tag_factory() :: Strainer.Tag.t()
  def tag_factory do
    %Tag{
      title: sequence(:title, &"Tag Title #{&1}"),
      popularity: sequence(:popularity, & &1)
    }
  end
end
