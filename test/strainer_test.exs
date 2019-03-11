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

      cases = [
        [tag_title: tag.title],
        [tag_title_shorrtcut: tag.title]
      ]

      cases
      |> Enum.each(fn keyword ->
        result =
          Post
          |> PostFilters.filtered(keyword)
          |> Repo.all()

        assert length(result) == 1
        [%{id: id}] = result
        assert id == post.id
      end)
    end

    test "filter by tag name and popularity" do
      tag = insert(:tag, popularity: 5)
      post = insert(:post, tags: [tag])

      result =
        Post
        |> PostFilters.filtered(tag_title: tag.title, tag_popularity: 5)
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end
  end
end
