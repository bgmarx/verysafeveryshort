defmodule VerySafeVeryShort.Lookup do
  alias VerySafeVeryShort.{Cache, Redis}

  def lookup(key) do
    case local_cache(key) do
      {:ok, entry} ->
        {:ok, {:local, entry}}

      {:error, :not_found_in_local_cache} ->
        redis_lookup(key)
    end
  end

  def local_cache(key) do
    case Cache.lookup(Cache.cache(), key) do
      [] ->
        {:error, :not_found_in_local_cache}

      entry ->
        [_ | entry] =
          entry
          |> List.first()
          |> Tuple.to_list()

        {:ok, entry}
    end
  end

  def redis_lookup(key) do
    case Redis.lookup(key) do
      {:error, :not_found} ->
        {:error, :not_found_in_redis}

      {:ok, entry} ->
        Cache.insert(Cache.cache(), %{
          key: Enum.at(entry, 1),
          url: Enum.at(entry, 3),
          sha: Enum.at(entry, 5)
        })

        {:ok, {:redis, entry}}
    end
  end
end
