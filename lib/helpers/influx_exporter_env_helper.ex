defmodule InfluxExporterEnvHelper do

  def get_influx_url() do
    System.get_env("INFLUX_URL")
  end

  def get_influx_dbname() do
    System.get_env("INFLUX_DBNAME")
  end
end
