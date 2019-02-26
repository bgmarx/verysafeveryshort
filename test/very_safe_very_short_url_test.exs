defmodule VerySafeVeryShortUrlTest do
  use ExUnit.Case
  alias VerySafeVeryShort.Url
  @url "verysafeveryshort.com"

  describe "from url to short url" do
    test "hashes url" do
      hashed =
        :crypto.hash(:sha256, @url)
        |> Base.encode16()
        |> String.downcase()

      assert Url.hash(@url).sha == hashed
    end

    test "key is last ten elements of the hash" do
      url_struct = Url.hash(@url)
      assert url_struct.key == String.slice(url_struct.sha, 54, 64)
    end
  end
end
