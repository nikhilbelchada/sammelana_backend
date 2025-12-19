defmodule SammelanaWeb.Auth.KeySource.Google do
  @moduledoc false

  @endpoint_url "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

  @behaviour SammelanaWeb.Auth.KeySource

  def fetch_certificates do
    with {:ok, body} <- get(@endpoint_url),
         {:ok, json_data} <- Jason.decode(body) do
      {:ok, convert_to_jose_keys(json_data)}
    else
      _ ->
        :error
    end
  end

  defp get(url) do
    {:ok, 200, _resp_header, client_ref} = :hackney.request(:get, url, [], "", [])

    {:ok, _body} = :hackney.body(client_ref)
  end

  defp convert_to_jose_keys(json_data) do
    json_data
    |> Enum.map(fn {key, value} ->
      case JOSE.JWK.from_pem(value) do
        [] -> {key, nil}
        jwk -> {key, jwk}
      end
    end)
    |> Enum.filter(fn {_, value} -> not is_nil(value) end)
  end
end
