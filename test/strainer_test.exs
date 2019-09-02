defmodule StrainerTest do
  use Strainer.TestCase
  alias Strainer.{Post, PostFilters, Repo}
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

    test "filter by record field and association field" do
      tag = insert(:tag, popularity: 5)
      post = insert(:post, tags: [tag])

      result =
        Post
        |> PostFilters.filtered(tag_popularity: 5, title: post.title)
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end
  end

  describe ".filtered/3 with default adapter" do
    test "filter by schema field" do
      post = insert(:post)

      result =
        Post
        |> PostFilters.filtered([title: post.title], Strainer.Adapters.Default)
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end
  end

  describe ".filtered/3 with advanced adapter" do
    test "filter by schema field" do
      post = insert(:post)

      result =
        Post
        |> PostFilters.filtered(
          [%{kind: :clause, filter: :title, predicate: :eq, value: post.title}],
          Strainer.Adapters.Advanced
        )
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end

    test "filter by multiple fields with injections" do
      tag = insert(:tag, popularity: 5)
      post = insert(:post, tags: [tag])

      result =
        Post
        |> PostFilters.filtered(
          [
            %{kind: :clause, filter: :title, predicate: :eq, value: post.title},
            %{kind: :clause, filter: :tag_popularity, predicate: :eq, value: 5}
          ],
          Strainer.Adapters.Advanced
        )
        |> Repo.all()

      assert length(result) == 1
      [%{id: id}] = result
      assert id == post.id
    end

    test "filter with multiple clauses" do
      tag = insert(:tag, popularity: 5)
      post = insert(:post, tags: [tag])
      another_tag = insert(:tag, popularity: 2)
      next_post = insert(:post, tags: [another_tag])

      result =
        Post
        |> PostFilters.filtered(
          [
            %{
              kind: :clauses,
              inject_with: :or,
              clauses: [
                %{
                  kind: :clause,
                  filter: :title,
                  predicate: :eq,
                  value: next_post.title
                },
                %{
                  kind: :clause,
                  filter: :tag_popularity,
                  predicate: :eq,
                  value: 5
                }
              ]
            }
          ],
          Strainer.Adapters.Advanced
        )
        |> Repo.all()

      assert length(result) == 2

      result =
        Post
        |> PostFilters.filtered(
          [
            %{
              kind: :clauses,
              inject_with: :or,
              clauses: [
                %{
                  kind: :clauses,
                  inject_with: :and,
                  clauses: [
                    %{
                      kind: :clause,
                      filter: :tag_popularity,
                      predicate: :eq,
                      value: 3
                    },
                    %{
                      kind: :clause,
                      filter: :title,
                      predicate: :eq,
                      value: "Title"
                    }
                  ]
                },
                %{
                  kind: :clause,
                  filter: :tag_popularity,
                  predicate: :eq,
                  value: 5
                }
              ]
            }
          ],
          Strainer.Adapters.Advanced
        )
        |> Repo.all()

      assert length(result) == 1
      [%{id: id }] = result
      assert id == post.id
    end

    test "filter by all conditions" do
      cases = %{
        title: [
          {:eq, "3"},
          {:ne, "3"},
          {:lt, "3"},
          {:lte, "3"},
          {:gte, "3"},
          {:gt, "3"},
          {:null, false},
          {:null, true},
          {:in, ["1", "2", "3"]},
          {:not_like, "foo"},
          {:ilike, "bar"},
          {:not_between, ["2", "4"]},
          {:between, ["2", "4"]},
          {:contains, "2"},
          {:not_contains, "2"}
        ],
        tag_popularity: [
          {:eq, 3},
          {:ne, 3},
          {:lt, 3},
          {:lte, 3},
          {:gte, 3},
          {:gt, 3},
          {:null, false},
          {:null, true},
          {:not_between, [2, 4]},
          {:between, [2, 4]},
          {:in, [1, 2, 3]}
        ],
        tag_title: [
          {:not_like, "foo"},
          {:ilike, "bar"},
          {:contains, "2"},
          {:not_contains, "2"}
        ]
      }

      # [
      #   {:tag_title, :not_like: "foo"}
      # ]

      Enum.each(cases, fn {filter, predicates} ->
        Enum.each(predicates, fn {predicate, value} ->
          Post
          |> PostFilters.filtered(
            [
              %{
                kind: :clause,
                filter: filter,
                predicate: predicate,
                value: value
              }
            ],
            Strainer.Adapters.Advanced
          )
        end)
      end)
    end
  end
end
