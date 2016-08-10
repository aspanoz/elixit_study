defmodule AppPhoenix.UserTest do
  use AppPhoenix.ModelCase

  alias AppPhoenix.User
  alias AppPhoenix.Factory

  @valid_attrs %{
    email: "test@test.com",
    password: "test1234",
    password_confirmation: "test1234",
    username: "testuser"
  }
  @invalid_attrs %{}
  @invalid_attrs_nil_pass %{
    email: "test@test.com",
    password: nil,
    password_confirmation: nil,
    username: "test"
  }

  setup do
    role = Factory.insert(:role)
    {:ok, role: role}
  end

  defp valid_attrs(role) do
    Map.put(@valid_attrs, :role_id, role.id)
  end


  @tag :model_user
  test "changeset with valid attributes", %{role: role} do
    changeset = User.changeset(%User{}, valid_attrs(role))
    assert changeset.valid?
  end

  # error - dublicate test
  # @tag :model_user
  # test "changeset with valid attributes" do
    # changeset = User.changeset(%User{}, @valid_attrs)
    # assert changeset.valid?
  # end

  @tag :model_user
  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  @tag :model_user
  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(
      @valid_attrs.password,
      Ecto.Changeset.get_change(changeset, :password_digest)
    )
  end

  @tag :model_user
  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, @invalid_attrs_nil_pass)
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end

end
