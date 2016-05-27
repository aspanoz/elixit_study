defmodule AppPhoenix.Post do
  @moduledoc '''
    Post model
  '''
  use AppPhoenix.Web, :model


  schema "posts" do
    field :title, :string
    field :body, :string
    # FK link
    belongs_to :user, AppPhoenix.User
    has_many :comments, AppPhoenix.Comment
    # created/updated timestamps
    timestamps
  end


  @required_fields ~w(title body)
  @optional_fields ~w()


  def changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
      |> strip_unsafe_body(params)
  end

  defp strip_unsafe_body(model, %{"body" => nil}) do
    model
  end

  defp strip_unsafe_body(model, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model
      |> put_change(:body, clean_body)
  end

  defp strip_unsafe_body(model, _) do
    model
  end

  def unsafe_changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end


end
