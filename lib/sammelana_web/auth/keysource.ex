defmodule SammelanaWeb.Auth.KeySource do
  @moduledoc false

  @callback fetch_certificates() :: :error | {:ok, list(JOSE.JWK.t())}

  def fetch_certificates do
    apply(
      Application.get_env(:sammelanaWeb, :auth_key_source, SammelanaWeb.Auth.KeySource.Google),
      :fetch_certificates,
      []
    )
  end
end
