defmodule InfluxExporterSup do
  use Supervisor

  def start_link do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def init([]) do
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end

end
