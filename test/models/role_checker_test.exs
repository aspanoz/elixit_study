defmodule AppPhoenix.RoleCheckerTest do

  use AppPhoenix.ModelCase

  alias AppPhoenix.Factory
  alias AppPhoenix.RoleChecker

  @tag :rolechecker_model
  test "admin? is true when user has an admin role" do
    admin_role = Factory.create(:role, admin: true)
    admin_user = Factory.create(:user, role: admin_role)
    assert RoleChecker.admin?(admin_user)
  end

  @tag :rolechecker_model
  test "admin? is false when user does not have an admin role" do
    user_role = Factory.create(:role)
    nonadmin_user = Factory.create(:user, role: user_role)
    refute RoleChecker.admin?(nonadmin_user)
  end
end
