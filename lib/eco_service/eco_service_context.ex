defmodule EcoService.EcoServiceContext do

  alias EcoService.Repo
  alias EcoService.EcoService.Community

  def fetch_all_communities() do
    Repo.all(Community)
  end
end
