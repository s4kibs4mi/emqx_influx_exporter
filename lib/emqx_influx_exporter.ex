defmodule EmqxInfluxExporter do
  use Application

  def start(type, args) do
    InfluxExporterMod.load([])
    InfluxExporterSup.start_link()
  end

  def stop(_app) do
    InfluxExporterMod.unload()
  end

end
