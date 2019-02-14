defmodule InfluxExporterModHelper do

  def is_system_message(msg) do
    case msg do
      {
        :message,
        _,
        _,
        :emqx_sys,
        _,
        _,
        _,
        _,
        _
      } -> true
      _ -> false
    end
  end

  def is_presence_message(msg) do
    case msg do
      {
        :message,
        _,
        _,
        :emqx_mod_presence,
        _,
        _,
        _,
        _,
        _
      } -> true
      _ -> false
    end
  end

  def is_message(msg) do
    cond do
      is_presence_message(msg) or is_system_message(msg) -> false
      true -> true
    end
  end

end
