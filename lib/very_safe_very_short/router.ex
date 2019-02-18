defmodule VerySafeVeryShort.Router do
  use Plug.Router
  alias VerySafeVeryShort.{Redis, Url}

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
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(%{url: url.key}))
        |> halt

      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(433, Jason.encode!(%{error: "error"}))
        |> halt
    end
  end

  get "/:url" do
    url = conn.params["url"]

    case Redis.lookup(url) do
      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, "Not Found")
        |> halt

      {:ok, hash} ->
        key = Enum.at(hash, 3)

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
end
