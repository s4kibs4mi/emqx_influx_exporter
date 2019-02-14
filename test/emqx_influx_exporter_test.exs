defmodule EmqxInfluxExporterTest do
  use ExUnit.Case
  doctest EmqxInfluxExporter

  test "greets the world" do
    assert EmqxInfluxExporter.hello() == :world
  end
end
