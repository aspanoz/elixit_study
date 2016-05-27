defmodule AppPhoenix.PostTest do
  use AppPhoenix.ModelCase

  alias AppPhoenix.Post
  import Ecto.Changeset, only: [get_change: 2]

  @valid_attrs %{"body" => "some content", "title" => "some content"}
  @invalid_attrs %{}

  @tag :model_post
  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  @tag :model_post
  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  @tag :model_post
  test "when the body includes a script tag" do
    content = "Hello <script type='javascript'>alert('foo');</script>"
    changeset = Post.changeset(%Post{}, %{ @valid_attrs | "body" => content})
    refute String.match? get_change(changeset, :body), ~r{<script>}
  end

  @tag :model_post
  test "when the body includes an iframe tag" do
    content = "Hello <iframe src='http://google.com'></iframe>"
    changeset = Post.changeset(%Post{}, %{@valid_attrs | "body" => content})
    refute String.match? get_change(changeset, :body), ~r{<iframe>}
  end

  @tag :model_post
  test "body includes a link tag" do
    content = "Hello <link>foo</link>"
    changeset = Post.changeset(%Post{}, %{@valid_attrs | "body" => content})
    refute String.match? get_change(changeset, :body), ~r{<link>}
  end

  @tag :model_post
  test "body includes no stripped tags" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert get_change(changeset, :body) == @valid_attrs["body"]
  end

end
