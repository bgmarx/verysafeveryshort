defmodule VerySafeVeryShort.Url do
  @moduledoc """
  Shortens a URL
    - sha256
    - key is last 10 digits of sha
  """
  defstruct [:key, :short_url, :url]

  def hash(url) do
    short = shorten(url)
    %__MODULE__{key: key(short), short_url: short, url: url}
  end

  def hash_url(url) do
    :crypto.hash(:sha256, url)
    |> Base.encode16()
    |> String.downcase()
  end

  defp shorten(url), do: hash_url(url)

  defp key(hash), do: binary_part(hash, 64, -10)
end
