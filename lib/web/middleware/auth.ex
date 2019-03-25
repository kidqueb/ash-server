defmodule AppWeb.AuthMiddleware do
  @behavior Absinthe.Middleware

  if Mix.env == :dev do
    def call(resolution, _config) do
      resolution
    end
  end

  def call(resolution = %{context: %{current_user: _}}, _config) do
    resolution
  end

  def call(resolution, _config) do
    resolution
    |> Absinthe.Resolution.put_result(
      {:error,
       %{code: :unauthorized, error: "Not authenticated", message: "Not authenticated"}}
    )
  end
end
