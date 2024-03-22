# Script for populating the database. You can run it as
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
alias EcoService.EcoService.Waste
alias EcoService.EcoService.Schedule

# list_of_numbers = 1..10

# for number <- list_of_numbers do

  monday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Monday",
    }
  )
  tuesday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Tuesday",
    }
  )

  wednesday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Wednesday",
    }
  )

  thursday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Thursday",
    }
  )

  friday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Friday",
    }
  )

  saturday =
  Repo.insert!(
    %Schedule{
      day_of_week: "Saturday",
    }
  )


  Repo.insert!(
    %Community{
      name: "Eco Service 1",
      location_area_zone: "Auroshilpam 1",
      schedule_id: monday.id
    }
  )

  Repo.insert!(
    %Community{
      name: "Eco Service 2",
      location_area_zone: "Auroshilpam 2",
      schedule_id: monday.id
    }
  )

  Repo.insert!(
    %Community{
      name: "Purnam",
      location_area_zone: "Auroville",
      schedule_id: monday.id
    }
  )


  Repo.insert!(
    %Community{
      name: "Eco ",
      location_area_zone: "Auroshilpam 5",
      schedule_id: tuesday.id
    }
  )

  Repo.insert!(
    %Community{
      name: "Ecoooo",
      location_area_zone: "Auroshilp",
      schedule_id: tuesday.id
    }
  )

  Repo.insert!(
    %Community{
      name: "talam",
      location_area_zone: "sacred grooves",
      schedule_id: wednesday.id
    }
  )

  list_of_numbers = 1..100

  for number <- list_of_numbers do

    community =  Repo.insert!(
      %Community{
        name: "Eco Service #{number}",
        location_area_zone: "Auroshilpam #{number}"
      }
    )

    Repo.insert!(
      %Waste{
        comments: "No comments #{number}",
        date: ~D[2024-01-29],
        glass_bags: 23,
        kg_of_glass: 12.99,
        kg_of_mixed: 25.77,
        kg_of_paper: 50.00,
        kg_of_plastic: 51.00,
        kg_of_sanitory: 19.00,
        kg_of_seg_lf: 13.44,
        mixed_bags: 12,
        paper_bags: 30,
        plastic_bags: 40,
        sanitory_bags: 50,
        seg_lf_bags: 10,
        community_id: community.id
      }
    )
  end
