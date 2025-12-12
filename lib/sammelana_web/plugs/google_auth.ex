defmodule SammelanaWeb.Plugs.GoogleAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- {:ok, %{}},
         true <- claims["aud"] == System.get_env("GOOGLE_ANDROID_CLIENT_ID") do
      assign(conn, :current_user, claims)
    else
      _ -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
