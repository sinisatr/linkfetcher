defmodule LinkFetcherTest do
  use ExUnit.Case

  test "get good data from good link" do
    {atom, %{assets: assets, links: links}} = LinkFetcher.fetch("https://elixir-lang.org/")
    assert atom == :ok
    assert is_list(assets)
    assert is_list(links)
  end

  test "get error for url which doesnt exists" do
    assert LinkFetcher.fetch("www.johndoewrong.rs") == {:error, :nxdomain}
  end

  test "get error for wrong url" do
    assert LinkFetcher.fetch("123") == {:error, :ehostunreach}
  end
end
