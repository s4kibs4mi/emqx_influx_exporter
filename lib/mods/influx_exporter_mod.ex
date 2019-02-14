defmodule InfluxExporterMod do

  def hook_add(a, b, c) do
    :emqx.hook(a, b, c)
  end

  def hook_del(a, b) do
    :emqx.unhook(a, b)
  end

  def load(env) do
    hook_add(:"client.connected", &InfluxExporterMod.on_client_connected/4, [env])
    hook_add(:"message.publish", &InfluxExporterMod.on_message_publish/2, [env])
    hook_add(:"message.delivered", &InfluxExporterMod.on_message_delivered/3, [env])
    hook_add(:"message.acked", &InfluxExporterMod.on_message_acked/3, [env])
    hook_add(:"client.disconnected", &InfluxExporterMod.on_client_disconnected/3, [env])
  end

  def unload do
    hook_del(:"client.connected", &InfluxExporterMod.on_client_connected/4)
    hook_del(:"message.publish", &InfluxExporterMod.on_message_publish/2)
    hook_del(:"message.delivered", &InfluxExporterMod.on_message_delivered/3)
    hook_del(:"message.acked", &InfluxExporterMod.on_message_acked/3)
    hook_del(:"client.disconnected", &InfluxExporterMod.on_client_disconnected/3)
  end

  def on_client_connected(client, connect_code, connect_info, _env) do
    data = ""
    data = "#{data}client_connected client=\"#{client.client_id}\"\n"
    data = "#{data}client_connected username=\"#{client.username}\""

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok, client}
  end

  def on_message_publish(msg, _env) do
    {type, id, qos, client_id, flags, user_info, topic, payload, time} = msg

    if InfluxExporterModHelper.is_message(msg) do
      data = ""
      data = "#{data}message_published client=\"#{client_id}\"\n"
      data = "#{data}message_published topic=\"#{topic}\"\n"
      data = "#{data}message_published type=\"#{type}\"\n"
      data = "#{data}message_published qos=#{qos}i\n"
      data = "#{data}message_published id=\"#{id}\""

      case InfluxExporterCLIHelper.write_event(data) do
        :ok -> :logger.info("Write successful")
        {:error, err} -> :logger.error(err)
      end
    end

    {:ok, msg}
  end

  def on_message_delivered(client, msg, _env) do
    {type, id, qos, client_id, flags, user_info, topic, payload, time} = msg

    data = ""
    data = "#{data}message_delivered client=\"#{client_id}\"\n"
    data = "#{data}message_delivered topic=\"#{topic}\"\n"
    data = "#{data}message_delivered type=\"#{type}\"\n"
    data = "#{data}message_delivered qos=#{qos}i\n"
    data = "#{data}message_delivered id=\"#{id}\""

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok, msg}
  end

  def on_message_acked(client, msg, _env) do
    {type, id, qos, client_id, flags, user_info, topic, payload, time} = msg

    data = ""
    data = "#{data}message_acked client=\"#{client_id}\"\n"
    data = "#{data}message_acked topic=\"#{topic}\"\n"
    data = "#{data}message_acked type=\"#{type}\"\n"
    data = "#{data}message_acked qos=#{qos}i\n"
    data = "#{data}message_acked id=\"#{id}\""

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok, msg}
  end

  def on_client_disconnected(client, reason_code, _env) do
    data = ""
    data = "#{data}client_disconnected client=\"#{client.client_id}\"\n"
    data = "#{data}client_disconnected username=\"#{client.username}\""

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok}
  end

end
