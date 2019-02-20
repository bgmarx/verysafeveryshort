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
           "sha",
           url_struct.short_url,
           "url",
           url_struct.url,
           "counter",
           url_struct.counter
         ]) do
      {:ok, "OK"} -> {:ok, url_struct}
      nil -> {:error, :not_found}
    end
  end

  def increment(hash) do
    updated_counter = String.to_integer(Enum.at(hash, 5)) + 1

    insert(%{
      key: Enum.at(hash, 1),
      url: Enum.at(hash, 3),
      short_url: Enum.at(hash, 7),
      counter: updated_counter
    })
  end
end
