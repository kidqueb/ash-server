defmodule AshTpl.Factory do
  use ExMachina.Ecto, repo: AshTpl.Repo
  use AshTpl.UserFactory
end
