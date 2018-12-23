# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
     # MyApp.Repo.insert!(%MyApp.Auth.User{email: "test", password: "pass", role: "admin"})
     MyApp.Auth.create_user(%{email: "test", password: "pass", role: "admin"})

#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
