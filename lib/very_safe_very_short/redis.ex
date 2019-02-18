defmodule VerySafeVeryShort.Redis do
  @moduledoc """
  Helper Redis functions
  """
  def lookup(key) do
    case Redix.command(:redix, ["HGETALL", key]) do
      {:ok, []} ->
        {:error, :not_found}

      {:ok, entry} ->
        {:ok, entry}
    end
  end

  def insert(url_struct) do
    case Redix.command(:redix, [
           "HMSET",
           url_struct.key,
           "key",
           url_struct.key,
           "url",
           url_struct.url
         ]) do
      {:ok, "OK"} -> {:ok, url_struct}
      _ -> :error
    end
  end
end
