defmodule VerySafeVeryShort.Router do
  use Plug.Router
  alias VerySafeVeryShort.{Cache, Redis, Url}

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/shorten" do
    url_struct =
      conn.body_params["url"]
      |> Url.hash()

    case Redis.insert(url_struct) do
      {:ok, %Url{} = url} ->
        Cache.insert(cache(), url)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(%{url: url.key}))
        |> halt

      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "error"}))
        |> halt
    end
  end

  get "/:key" do
    key = conn.params["key"]

    case lookup(key) do
      {:error, :not_found_in_redis} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, "Not Found")
        |> halt

      {:ok, {:redis, entry}} ->
        key = Enum.at(entry, 3)

        conn
        |> put_resp_header("location", key)
        |> send_resp(302, "application/json")
        |> halt

      {:ok, {:local, entry}} ->
        key = Enum.at(entry, 3)

        conn
        |> put_resp_header("location", key)
        |> send_resp(302, "application/json")
        |> halt
    end
  end

  match _ do
    conn
    |> send_resp(404, "")
    |> halt
  end

  def cache do
    GenServer.whereis(Cache)
  end

  def lookup(key) do
    case local_cache(key) do
      {:ok, entry} ->
        {:ok, {:local, entry}}

      {:error, :not_found_in_local_cache} ->
        redis_lookup(key)
    end
  end

  def local_cache(key) do
    case Cache.lookup(cache(), key) do
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
        Cache.insert(cache(), %{key: Enum.at(entry, 1), url: Enum.at(entry, 3)})
        {:ok, {:redis, entry}}
    end
  end
end
