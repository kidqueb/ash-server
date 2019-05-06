defmodule <%= inspect context.module %>.Policy do
  @moduledoc """
  Authorization policies for the <%= context.name %> context.
  """
  @behaviour Bodyguard.Policy
  alias <%= context.base_module %>.Accounts.User
end
