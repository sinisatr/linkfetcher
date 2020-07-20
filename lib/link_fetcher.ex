defmodule LinkFetcher do
  @moduledoc """
  Link fetcher is exercise project for fetching all anchor and image urls from given URL
  """

  require Logger

  @max_redirect Application.get_env(:link_fetcher, :max_redirect)
  @proxy Application.get_env(:link_fetcher, :proxy)

  @typedoc "valid url"
  @type url :: binary

  @doc """
    Fetches all links(urls in anchor tags) and assets(all urls in img tags)
    Example:
      LinkFetcher.fetch("https://elixir-lang.org/")
      {:ok,
       %{
         assets: ["https://i.imgur.com/AvxW0BR.jpg", "https://esl-conf-staging.s3.eu-central-..."],
         links: ["https://elixirsurvey.typeform.com/to/yYmJv1","https://hexdocs.pm/ex_unit/"...]
       }}
  """
  @spec fetch(url) :: map | {:error, reason :: binary}
  def fetch(url) do
    get(url, 0)
  end

  defp get(url, redirection_counter) when redirection_counter >= @max_redirect do
    Logger.debug("More than #{inspect(@max_redirect)} redirections for the URL: #{inspect(url)}")

    {:error, :max_redirections_made}
  end

  defp get(url, redirection_counter) do
    Logger.debug("Get links for URL: #{inspect(url)},
      redirection counter: #{inspect(redirection_counter)}")

    response = send_request(url, @proxy)

    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, headers: headers}}
      when status_code > 300 and status_code < 400 ->
        case get_location_header(headers) do
          [url] when is_binary(url) ->
            Logger.debug("Response after GET request is status code: #{inspect(status_code)}")
            get(url, redirection_counter + 1)

          _ ->
            Logger.error("Can't get location from response header for given URL: #{inspect(url)}")
            {:error, :no_location_header}
        end

      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Logger.debug("Response after GET request is status code: 200")
        {:ok, fetch_data(body)}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        Logger.error("Response after GET request is status code: #{inspect(code)}")
        {:error, code}

      {:error, %HTTPoison.Error{id: _, reason: res}} ->
        Logger.error("Error after GET request. Reason: #{inspect(res)}")
        {:error, res}
    end
  end

  defp fetch_data(body) do
    {:ok, html} = Floki.parse_document(body)

    links =
      html
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> filter_urls()

    assets =
      html
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> filter_urls()

    %{assets: assets, links: links}
  end

  # get routed location
  defp get_location_header(headers) do
    for {key, value} <- headers, String.downcase(key) == "location" do
      value
    end
  end

  # send get request
  defp send_request(url, %{use: true} = proxy) do
    Logger.debug("Send GET request for URL: #{inspect(url)} using proxy: #{inspect(proxy)}")
    HTTPoison.get(url, [], proxy: {proxy.host, proxy.port})
  end

  defp send_request(url, %{use: false}) do
    Logger.debug("Send GET request for URL: #{inspect(url)}")
    HTTPoison.get(url)
  end

  # filter non-needed links like '#', '/images.../', 'javascript.source...'
  defp filter_urls(list_of_urls) do
    reg_exp = ~r/^http/
    Enum.filter(list_of_urls, &Regex.match?(reg_exp, &1))
  end
end
