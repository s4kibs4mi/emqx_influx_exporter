defmodule InfluxExporterCLIHelper do
  use Tesla

  plug Tesla.Middleware.BaseUrl, InfluxExporterEnvHelper.get_influx_url()

  def write_event(data) do
    :logger.info(data)

    case post("/write?db=" <> InfluxExporterEnvHelper.get_influx_dbname(), data) do
      {:ok, res} ->
        cond do
          res.status >= 200 && res.status < 300 -> :ok
          true -> {:error, "unprocessable entity"}
        end
      err -> {:error, err}
    end
  end

end
