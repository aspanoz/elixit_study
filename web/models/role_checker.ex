defmodule AppPhoenix.RoleChecker do
  alias AppPhoenix.Repo
  alias AppPhoenix.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end

end
