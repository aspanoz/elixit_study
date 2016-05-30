defmodule AppPhoenix.User do
  @moduledoc '''
    User model
  '''
  use AppPhoenix.Web, :model

  alias AppPhoenix.MyDebuger

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "users" do
    field :username, :string
    field :email, :string
    field :password_digest, :string
    # FK link
    has_many :posts, AppPhoenix.Post
    belongs_to :role, AppPhoenix.Role
    # created/updated timestamps
    timestamps
    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end


  @required_fields ~w(username email password password_confirmation role_id)
  @optional_fields ~w()


  def changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
      |> hash_password
      # |> password_change(get_change(model, :password))
  end


  defp hash_password(model) do
    model
      |> password_change(get_change(model, :password))
  end


  defp password_change(model, password) when is_nil(password) do
    model
  end
  defp password_change(model, password) do
    model
      |> put_change(:password_digest, hashpwsalt(password))
  end


end
