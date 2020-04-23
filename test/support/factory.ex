defmodule AshServer.Factory do
  use ExMachina.Ecto, repo: AshServer.Repo
  use AshServer.UserFactory
end
