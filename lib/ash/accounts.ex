defmodule Ash.Accounts do
  @moduledoc """
  Handles user creation and authorization.
  """

  import Ecto.Query, warn: false

  alias Ash.{Repo, Accounts, Mailer, Email}
  alias Ash.Accounts.{User, AuthToken, AuthRequest}
  alias AshWeb.Endpoint

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  # sets expiration for our auth tokens (30 min)
  @token_max_age 30 * 60

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users, do: Repo.all(User)

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
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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

  @doc """
  Creates a auth_token.

  ## Examples

      iex> create_auth_token(user)
      {:ok, %AuthToken{}}

      iex> create_auth_token(user)
      {:error, %Ecto.Changeset{}}

  """
  def create_auth_token(user) do
    %AuthToken{}
    |> AuthToken.changeset(user)
    |> Repo.insert()
  end

  @doc """
  Deletes a AuthToken.

  ## Examples

      iex> delete_auth_token(auth_token)
      {:ok, %AuthToken{}}

      iex> delete_auth_token(auth_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_auth_token(%AuthToken{} = auth_token) do
    Repo.delete(auth_token)
  end

  @doc """
  Gets a single auth_request.

  Raises `Ecto.NoResultsError` if the AuthRequest does not exist.

  ## Examples

      iex> get_auth_request!(123)
      %UAuthRequestser{}

      iex> get_auth_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_auth_request!(id), do: Repo.get!(AuthRequest, id)

  @doc """
  Creates a auth_request.

  ## Examples

      iex> create_auth_request(user)
      {:ok, %AuthRequest{}}

      iex> create_auth_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_auth_request(attrs \\ %{}) do
    %AuthRequest{}
    |> AuthRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a auth_request.

  ## Examples

      iex> delete_auth_request(auth_request)
      {:ok, %AuthRequest{}}

      iex> delete_auth_request(auth_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_auth_request(%AuthRequest{} = auth_request) do
    Repo.delete(auth_request)
  end

  @doc """
  Creates and sends a new magic login token to the user or email.
  """
  def provide_token(nil), do: {:error, :not_found}
  def provide_token(email) when is_binary(email) do
    Accounts.get_user_by_email!(email)
    |> send_token()
  end
  def provide_token(user = %User{}) do
    send_token(user)
  end

  @doc """
  Checks the given token.
  """
  def verify_token_value(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > datetime_add(^NaiveDateTime.utc_now(), ^(@token_max_age * -1), "second"))
    |> Repo.one()
    |> verify_token()
  end

  # """
  # Verified the auth_token
  # nil -> Unexpired token could not be found.
  # token -> Loads the user and deletes the token.
  # """
  defp verify_token(nil), do: {:error, :invalid}
  defp verify_token(token) do
    token =
      token
      |> Repo.preload(:user)
      |> Repo.delete!()

    user_id = token.user.id

    # verify the token matching the user id
    case Phoenix.Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} -> {:ok, token.user}
      {:error, reason} -> {:error, reason} # reason can be :invalid or :expired
    end
  end

  # """
  # Emails a login request to a user.
  # nil -> User could not be found by email.
  # user -> Creates a token and sends it to the user.
  # """
  defp send_token(nil), do: {:error, :not_found}
  defp send_token(user) do
    user
    |> create_token()
    |> Email.login_request(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # """
  # Creates a new token for the given user and returns the token value.
  # """
  defp create_token(user) do
    with {:ok, auth_token} <- create_auth_token(user) do
      auth_token.value
    end
  end

  # """
  # Check a given password vs a user's actual password
  # """
  def authenticate_password(email, given_password) do
    get_user_by_email!(email)
    |> check_password(given_password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}
  defp check_password(%User{password_hash: ""}, _) do
    {:error, "Incorrect email or password"}
  end
  defp check_password(user, given_password) do
    case Argon2.check_pass(user, given_password) do
      {:ok, user} -> {:ok, user}
      {:error, _reason} -> {:error, "Incorrect email or password"}
    end
  end
end
