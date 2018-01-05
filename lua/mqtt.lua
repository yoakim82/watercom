-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client("vattenkanna", 120)

m:lwt("vattenkanna/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
    if topic == "cmnd/vattenkanna/vattna" then
      num = tonumber(data)
      if num >0 then
        w2(num)
      end
    end
  end
end)


-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect("192.168.2.4", 1883, 0, function(client)
  print("connected")
 
  -- subscribe topic with qos = 0
  client:subscribe("cmnd/vattenkanna/vattna", 0, function(client) print("subscribe success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("stat/vattenkanna/result", "0", 0, 0, function(client) print("sent") end)
end,
function(client, reason)
  print("failed reason: " .. reason)
end)
