-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client("humTemp1", 120)

m:lwt("humTemp1/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" )
end)


-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect("192.168.2.4", 1883, 0, function(client)
  print("connected")
 
  client:subscribe("cmnd/humTemp1", 0, function(client) print("subscribe success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("tele/humTemp1/temp", "0", 0, 0, function(client) print("sent") end)
  client:publish("tele/humTemp1/hum", "0", 0, 0, function(client) print("sent") end)

end,
function(client, reason)
  print("failed reason: " .. reason)
end)
