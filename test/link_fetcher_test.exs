defmodule LinkFetcherTest do
  use ExUnit.Case
  doctest LinkFetcher

  test "get good data from good link" do
    expected_data = %{
      assets: [
        "https://i.imgur.com/AvxW0BR.jpg",
        "https://esl-conf-staging.s3.eu-central-1.amazonaws.com/esl-conf-stg/media/files/000/000/935/original/elixirconfeu2020-elixirlang.jpg"
      ],
      links: [
        "https://elixirsurvey.typeform.com/to/yYmJv1",
        "https://hexdocs.pm/ex_unit/",
        "https://hexdocs.pm/mix/",
        "https://hex.pm/",
        "https://hexdocs.pm/",
        "https://hexdocs.pm/iex/",
        "https://www.heroku.com",
        "https://www.whatsapp.com",
        "https://klarna.com",
        "https://virtual.elixirconf.eu/",
        "https://www2.elixirconf.eu/l/23452/2019-11-25/6t44sx",
        "https://github.com/elixir-lang/elixir",
        "https://twitter.com/elixirlang",
        "http://doc.honeypot.io/elixir-documentary-2018/?utm_source=elixir_home&utm_medium=referral",
        "https://hex.pm",
        "http://elixirforum.com",
        "https://elixir-slackin.herokuapp.com/",
        "https://discord.gg/elixir",
        "http://elixir.meetup.com",
        "https://github.com/elixir-lang/elixir/wiki",
        "https://erlef.org/"
      ]
    }

    {atom, data} = LinkFetcher.fetch("https://elixir-lang.org/")
    assert atom == :ok
    assert data == expected_data
  end

  test "get error for url which doesnt exists" do
    assert LinkFetcher.fetch("www.johndoewrong.rs") == {:error, :nxdomain}
  end

  test "get error for wrong url" do
    assert LinkFetcher.fetch("123") == {:error, :ehostunreach}
  end
end
