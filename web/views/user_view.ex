defmodule AppPhoenix.UserView do
  use AppPhoenix.Web, :view

  def roles_for_select(roles) do
    roles
      |> Enum.map(&["#{&1.name}": &1.id])
      # Enum.map(roles, fn role -> ["#{role.name}": role.id] end)
      |> List.flatten
  end

end
