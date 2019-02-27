defmodule StrainerTest do
  use Strainer.TestCase
  alias Strainer.{PostFilters, Post, Repo}
  import Strainer.Factory

  describe ".filtered/2" do
    test "filter by schema field" do
      post = insert(:post)

      result =
        Post
        |> PostFilters.filtered(title: post.title)
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end

    test "filter by tag name association" do
      tag = insert(:tag)
      post = insert(:post, tags: [tag])

      result =
        Post
        |> PostFilters.filtered(tag_title: tag.title)
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end
  end
end
