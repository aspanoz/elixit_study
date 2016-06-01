defmodule AppPhoenix.Role do
  @moduledoc '''
    Role model
  '''
  use AppPhoenix.Web, :model

  schema "roles" do
    field :name, :string
    field :admin, :boolean, default: false
    # FK link
    has_many :users, AppPhoenix.User
    # created/updated timestamps
    timestamps
  end

  @required_fields ~w(name admin)
  @optional_fields ~w()

  def changeset(model, params \\ %{}) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end
end
