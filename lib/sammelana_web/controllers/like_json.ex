defmodule SammelanaWeb.LikeJSON do
  alias Sammelana.Content.Like

  @doc """
  Renders a list of likes.
  """
  def index(%{likes: likes}) do
    %{data: for(like <- likes, do: data(like))}
  end

  @doc """
  Renders a single like.
  """
  def show(%{like: like}) do
    %{data: data(like)}
  end

  defp data(%Like{} = like) do
    %{
      id: like.id,
      meta: like.meta
    }
  end
end
