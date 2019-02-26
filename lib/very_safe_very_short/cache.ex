defmodule VerySafeVeryShort.Cache do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [{:name, __MODULE__} | opts])
  end

  def lookup(pid, key) do
    GenServer.call(pid, {:lookup, key})
  end

  def insert(pid, url_struct) do
    GenServer.call(pid, {:insert, url_struct})
  end

  def cache do
    GenServer.whereis(__MODULE__)
  end

  def init(:ok) do
    state = create_table()
    {:ok, state}
  end

  def handle_call({:lookup, key}, _from, state) do
    key = :ets.lookup(:local_cache, key)
    {:reply, key, state}
  end

  def handle_call({:insert, url_struct}, _from, state) do
    :ets.insert(
      :local_cache,
      {url_struct.key, "key", url_struct.key, "url", url_struct.url, "sha", url_struct.sha}
    )

    {:reply, url_struct, state}
  end

  defp create_table do
    :ets.new(:local_cache, [:named_table, :public, :set])
  end
end
