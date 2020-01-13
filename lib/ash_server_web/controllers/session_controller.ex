defmodule AshServerWeb.SessionController do
  use AshServerWeb, :controller

  alias AshServer.Accounts
  alias AshServer.Accounts.User
  alias AshServerWeb.AuthPlug

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Accounts.get_user_by_username!(username) do
      %User{email: email} ->
        create(conn, %{
          "user" => %{
            "email" => email,
            "password" => password
          }
        })

      nil ->
        conn
        |> put_status(401)
        |> json(%{ error: %{ status: 401, message: "Invalid credentials" }})
    end
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        json(conn, %{
          data: %{
            token: conn.private[:api_auth_token],
            renewToken: conn.private[:api_renew_token],
            user: %{
              email: conn.assigns.current_user.email,
            }
          }
        })

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> AuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{
          data: %{
            token: conn.private[:api_auth_token],
            renewToken: conn.private[:api_renew_token],
            user: %{
              name: conn.assigns.current_user.name,
              username: conn.assigns.current_user.username
            }
          }
        })
    end
  end

  def delete(conn, _params) do
    {:ok, conn} = Pow.Plug.clear_authenticated_user(conn)

    json(conn, %{data: %{}})
  end

  def me(%{assigns: %{current_user: nil}} = conn, _params) do
    response = %{
      error: %{
        status: 401,
        message: "Session expired"
      }
    }

    json(conn, response)
  end

  def me(%{assigns: %{current_user: current_user}} = conn, _params) do
    response = %{
      data: %{
        user: %{
          username: current_user.username,
          name: current_user.name
        }
      }
    }

    json(conn, response)
  end

  def me(conn, _params) do
    json(conn, %{
      error: %{
        status: 500,
        message: "No session"
      }
    })
  end
end
