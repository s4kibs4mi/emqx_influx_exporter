defmodule InfluxExporterCLIHelper do
  use Tesla

  plug Tesla.Middleware.BaseUrl, InfluxExporterEnvHelper.get_influx_url()

  def write_event(data) do
    case post("/write?db=" <> InfluxExporterEnvHelper.get_influx_dbname(), data) do
      {:ok, res} -> :ok
      err -> {:error, err}
    end
  end

end
