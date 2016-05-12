defmodule AppPhoenix.Post do
  use AppPhoenix.Web, :model


  schema "posts" do
    field :title, :string
    field :body, :string
    # FK link
    belongs_to :user, AppPhoenix.User
    # created/updated timestamps
    timestamps
  end


  @required_fields ~w(title body)
  @optional_fields ~w()


  def changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end


end
