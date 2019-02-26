defmodule VerySafeVeryShort.Url do
  @moduledoc """
  Shortens a URL
    - sha256
    - key is last 10 digits of sha
  """
  @enforce_keys [:key, :sha, :url]
  defstruct [:key, :sha, :url]

  def hash(url) do
    sha = sha(url)
    %__MODULE__{key: key(sha), sha: sha, url: url}
  end

  def hash_url(url) do
    :crypto.hash(:sha256, url)
    |> Base.encode16()
    |> String.downcase()
  end

  defp sha(url), do: hash_url(url)

  defp key(hash), do: binary_part(hash, 64, -10)
end
