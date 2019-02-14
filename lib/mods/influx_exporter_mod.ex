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
    hook_add(:"client.disconnected", &InfluxExporterMod.on_client_disconnected/3, [env])
  end

  def unload do
    hook_del(:"client.connected", &InfluxExporterMod.on_client_connected/4)
    hook_del(:"message.publish", &InfluxExporterMod.on_message_publish/2)
    hook_del(:"message.delivered", &InfluxExporterMod.on_message_delivered/3)
    hook_del(:"client.disconnected", &InfluxExporterMod.on_client_disconnected/3)
  end

  def on_client_connected(client, connect_code, connect_info, _env) do
    data = "client_connected client=#{client.client_id},username=#{client.username}"

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok, client}
  end

  def on_message_publish(msg, _env) do
    {type, id, qos, client_id, flags, user_info, topic, payload, time} = msg

    if InfluxExporterModHelper.is_message(msg) do
      msg_data = "message_published client=#{client_id},topic=#{topic},type=#{type},qos=#{qos}i"

      case InfluxExporterCLIHelper.write_event(msg_data) do
        :ok -> :logger.info("Write successful")
        {:error, err} -> :logger.error(err)
      end
    end

    {:ok, msg}
  end

  def on_message_delivered(client, msg, _env) do
    {type, id, qos, client_id, flags, user_info, topic, payload, time} = msg

    data = "message_delivered client=#{client_id},topic=#{topic},type=#{type},qos=#{qos}i"

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok, msg}
  end

  def on_client_disconnected(client, reason_code, _env) do
    data = "client_disconnected client=#{client.client_id},username=#{client.username}"

    case InfluxExporterCLIHelper.write_event(data) do
      :ok -> :logger.info("Write successful")
      {:error, err} -> :logger.error(err)
    end

    {:ok}
  end

end
