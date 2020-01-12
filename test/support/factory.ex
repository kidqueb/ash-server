defmodule App.Factory do
  use ExMachina.Ecto, repo: App.Repo
  use App.UserFactory
end
