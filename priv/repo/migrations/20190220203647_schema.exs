defmodule Strainer.Repo.Migrations.Schema do
  use Ecto.Migration

  def change do
    create table("posts") do
      add(:title, :string)
    end

    create table("tags") do
      add(:title, :string)
    end

    create table("posts_tags", primary_key: false) do
      add(:post_id, references("posts"))
      add(:tag_id, references("tags"))
    end

  end
end
