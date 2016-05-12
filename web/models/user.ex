defmodule AppPhoenix.User do
  use AppPhoenix.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "users" do
    field :username, :string
    field :email, :string
    field :password_digest, :string
    # FK link
    has_many :posts, AppPhoenix.Post
    # created/updated timestamps
    timestamps
    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end


  @required_fields ~w(username email password password_confirmation)
  @optional_fields ~w()


  def changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
      |> hash_password
  end


  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
        |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end


end
