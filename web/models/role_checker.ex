defmodule AppPhoenix.RoleChecker do
  @moduledoc '''
    RoleChecker model
  '''

  alias AppPhoenix.Repo
  alias AppPhoenix.Role

  def admin?(user) when is_nil(user) do
    false
  end
  def admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end

end
