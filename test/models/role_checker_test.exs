defmodule AppPhoenix.RoleCheckerTest do

  use AppPhoenix.ModelCase

  alias AppPhoenix.Factory
  alias AppPhoenix.RoleChecker

  @tag :model_rolechecker
  test "admin? is true when user has an admin role" do
    admin_role = Factory.insert(:role, admin: true)
    admin_user = Factory.insert(:user, role: admin_role)
    assert RoleChecker.admin?(admin_user)
  end

  @tag :model_rolechecker
  test "admin? is false when user does not have an admin role" do
    user_role = Factory.insert(:role)
    nonadmin_user = Factory.insert(:user, role: user_role)
    refute RoleChecker.admin?(nonadmin_user)
  end
end
