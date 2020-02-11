defmodule AshServer.Accounts do
  @moduledoc """
  Handles user creation and authorization.
  """

  import Ecto.Query, warn: false
  use AshServer.Helpers.UsePolicy

  alias AshServer.Repo
  alias AshServer.Helpers.QueryHelpers
  alias AshServer.Accounts.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user and returns a tuple with result.

  ## Examples

      iex> fetch_user(123)
      {:ok, %User{}}

      iex> fetch_user(456)
      {:error, %EctoQuery{}}

  """
  def fetch_user(id), do: Repo.fetch(User, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

      iex> get_user(456)
      nil

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by their email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_email!("user@gmail.com")
      %User{}

      iex> get_user_by_email!("notuser@gmail.com")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email!(email), do: Repo.get_by(User, email: email)

  @doc """
  Returns a filtered list of users.

  ## Examples

      iex> list_users(%{email: "example@email.com"})
      [%User{}, ...]

  """
  def list_users(args \\ %{}) do
    User
    |> QueryHelpers.build_query(args)
    |> Repo.all
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
