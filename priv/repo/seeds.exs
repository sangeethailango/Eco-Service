# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EcoService.Repo.insert!(%EcoService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias EcoService.Repo
alias EcoService.EcoService.Community

list_of_numbers = 1..100

for number <- list_of_numbers do

  Repo.insert(
    %Community{
      name: "Eco Service #{number}",
      location_area_zone: "Auroshilpam #{number}"
    }
  )
end
