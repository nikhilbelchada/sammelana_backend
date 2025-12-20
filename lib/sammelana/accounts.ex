defmodule Sammelana.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Sammelana.Repo

  alias Sammelana.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a user by attrs (such as email) or creates one if not found.

  Returns {:ok, %User{}} on success.
  """
  def get_or_create_user(attrs) when is_map(attrs) do
    email = Map.get(attrs, "email") || Map.get(attrs, :email)

    case Repo.get_by(User, email: email) do
      %User{} = user ->
        {:ok, user, :existing}

      nil ->
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
        |> case do
          {:ok, user} ->
            {:ok, user, :created}

          {:error, %Ecto.Changeset{} = changeset} ->
            # If insert failed due to unique constraint (race), try to fetch again
            case Repo.get_by(User, email: email) do
              %User{} = u -> {:ok, u, :existing}
              _ -> {:error, changeset}
            end
        end
    end
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
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
