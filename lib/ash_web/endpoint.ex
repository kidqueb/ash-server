defmodule AshWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ash

  socket "/socket", AshWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Corsica,
    origins: "*",
    allow_headers: ["content-type"],
    log: [rejected: :info]

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_api_key",
    signing_salt: "Q/W647/4"

  plug AshWeb.Router
end
