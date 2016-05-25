defmodule AppPhoenix.UserView do
  @moduledoc '''
    web/views/user_view
    @TODO tests
  '''
  use AppPhoenix.Web, :view
  # alias AppPhoenix.MyDebuger

  def roles_for_select(roles) do
    roles
      # |> Enum.map(&["#{&1.name}": &1.id])
      # |> MyDebuger.echo_bypass
      |> Enum.map(&[Keyword.new([{String.to_atom(&1.name), &1.id}])])
      # |> MyDebuger.echo_bypass
      |> List.flatten
  end

end
