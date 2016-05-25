alias AppPhoenix.Repo
alias AppPhoenix.Role
alias AppPhoenix.User
import Ecto.Query, only: [from: 2]

# mix run priv/repo/seeds.exs

find_or_create_role = fn role_name, admin ->
  query = from r in Role,
    where: r.name == ^role_name and r.admin == ^admin
  case Repo.all(query) do
    [] ->
      %Role{}
        |> Role.changeset(%{name: role_name, admin: admin})
        |> Repo.insert!()
    _ ->
      IO.puts "Role: #{role_name} already exists, skipping"
  end
end

find_or_create_user = fn username, email, role ->
  query = from u in User,
    where: u.username == ^username and u.email == ^email
  case Repo.all(query) do
    [] ->
      %User{}
        |> User.changeset(%{
          username: username,
          email: email,
          password: "test",
          password_confirmation: "test",
          role_id: role.id
        })
        |> Repo.insert!()
    _ ->
      IO.puts "User: #{username} already exists, skipping"
  end
end

_user_role  = find_or_create_role.("User Role", false)
admin_role  = find_or_create_role.("Admin Role", true)
_admin_user = find_or_create_user.("admin", "admin@test.com", admin_role)
