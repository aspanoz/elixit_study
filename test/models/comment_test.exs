defmodule AppPhoenix.CommentTest do
  use AppPhoenix.ModelCase

  alias AppPhoenix.Comment
  alias AppPhoenix.Factory

  @valid_attrs %{approved: true, author: "some content", body: "some content"}
  @invalid_attrs %{}

  @tag :model_comment
  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  @tag :model_comment
  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end

  @tag :model_comment
  test "creates a comment associated with a post" do
    comment = Factory.create(:comment)
    assert comment.post_id
  end

end
