defmodule SammelanaWeb.Token do
  defp get_public_key(keyid) do
    case :ets.lookup(SammelanaWeb.Auth.KeyStore, keyid) do
      [{_keyid, key}] ->
        key

      [] ->
        nil
    end
  end

  @default_app :sammelana

  @spec issuer() :: String.t()
  @spec issuer(atom()) :: String.t()
  @doc ~S"""
  Returns the configured issuer

  """
  def issuer(app \\ @default_app), do: do_get_issuer(app)
  defp do_get_issuer(@default_app), do: Application.fetch_env!(@default_app, :issuer)

  defp do_get_issuer(app),
    do: Application.fetch_env!(app, @default_app) |> Keyword.fetch!(:issuer)

  @spec verify_token(String.t(), atom()) ::
          {:error, String.t()} | {:ok, String.t(), JOSE.JWT.t()}
  @doc ~S"""
  Verifies a token agains google's public keys. Returns {:ok, user_id, claims} if successful. {:error, _} otherwise.

  """
  def verify_token(token_string, app \\ @default_app) do
    issuer = issuer(app)

    with {:jwtheader, %{fields: %{"kid" => kid}}} <- peek_token_kid(token_string),
         {:key, %JOSE.JWK{} = key} <- {:key, get_public_key(kid)},
         {:verify, {true, %{fields: %{"iss" => ^issuer, "sub" => sub, "exp" => exp}} = data, _}} <-
           {:verify, JOSE.JWT.verify(key, token_string)},
         {:verify, {:ok, _}} <- {:verify, verify_expiry(exp)} do
      {:ok, sub, data}
    else
      :invalidjwt ->
        {:error, "Invalid JWT"}

      {:jwtheader, _} ->
        {:error, "Invalid JWT header, `kid` missing"}

      {:key, _} ->
        {:error, "Public key retrieved from google was not found or could not be parsed"}

      {:verify, {false, _, _}} ->
        {:error, "Invalid signature"}

      {:verify, {true, _, _}} ->
        {:error, "Signed by invalid issuer"}

      {:verify, {:expired, _}} ->
        {:error, "Expired JWT"}

      {:verify, _} ->
        {:error, "None of public keys matched auth token's key ids"}
    end
  end

  defp peek_token_kid(token_string) do
    {:jwtheader, JOSE.JWT.peek_protected(token_string)}
  rescue
    _ -> :invalidjwt
  end

  defp verify_expiry(exp) do
    cond do
      exp > DateTime.utc_now() |> DateTime.to_unix() -> {:ok, exp}
      true -> {:expired, exp}
    end
  end
end
