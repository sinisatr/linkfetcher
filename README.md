# LinkFetcher

LinkFetcher is exercise lib created to return links and assets for given URL

There is a function `​fetch(url)​` that fetches the page corresponding to the url and returns an object that has the following attributes:\
● Assets - a collection of urls present in the img tags on the page\
● Links - a collection of urls present in the anchor tags on the page

## Be sure to have

Erlang/OTP - 23\
Elixir - 1.10.4

## Running from CLI

Go to file destination and run:
```
# download needed dependencies
mix deps.get

# start interactive shell
iex --sname link_fetcher -S mix

# run fetch command
LinkFetcher.fetch("https://elixir-lang.org/")

# enjoy the view
{:ok,
 %{
   assets: ["https://i.imgur.com/AvxW0BR.jpg",
    "https://esl-conf-staging.s3.eu-central-1.amazonaws.com/esl-conf-stg/media/files/000/000/935/original/elixirconfeu2020-elixirlang.jpg"],
   links: ["https://elixirsurvey.typeform.com/to/yYmJv1",
    "https://hexdocs.pm/ex_unit/", "https://hexdocs.pm/mix/", "https://hex.pm/",
    "https://hexdocs.pm/", "https://hexdocs.pm/iex/", "https://www.heroku.com",
    "https://www.whatsapp.com", "https://klarna.com",
    "https://virtual.elixirconf.eu/",
    "https://www2.elixirconf.eu/l/23452/2019-11-25/6t44sx",
    "https://github.com/elixir-lang/elixir", "https://twitter.com/elixirlang",
    "http://doc.honeypot.io/elixir-documentary-2018/?utm_source=elixir_home&utm_medium=referral",
    "https://hex.pm", "http://elixirforum.com",
    "https://elixir-slackin.herokuapp.com/", "https://discord.gg/elixir",
    "http://elixir.meetup.com", "https://github.com/elixir-lang/elixir/wiki",
    "https://erlef.org/"]
 }}
```

## Implementing as dependency
```
# add dependency in mix.exs
  defp deps do
    [
      {:link_fetcher, git: "https://github.com/sinisatr/linkfetcher"}
    ]
  end
# Follow other instructions like `Running from CLI`
```

### Used dependencies
```
defp deps do
  [
    {:httpoison, "~> 1.6"},
    {:floki, "~> 0.27.0"}
  ]
end
```
### Assumptions
Return :error when url not sent \
Don't consider "#", "javascript.view...", "/images/storage..." as URLS\
Create tests\
Find good location for given urls like "www.youtube.com", "https://www.facebook.com/" \
Maximum 5 redirections per request\
Return `{:ok, map}` where map has keys - `:links` and `:assets`
