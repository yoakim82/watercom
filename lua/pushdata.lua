function pushData(filename, doSleep)

    m:publish("tele/humTemp1/temp", filename, 0, 0)

    print(filename)
    --port, path = 80, "/esp8266/data"
    --server = "192.168.1.78"

    --if wifi.sta.getip() == nil then
    --    print("No connection to AP...")
    --end
    
    --conn = net.createConnection(net.TCP, false)
    --conn:connect(80,server)
    --conn:send("GET "..path.."/"..filename.." HTTP/1.0\r\n".."Host: "..server.."\r\nConnection: close\r\nAccept: */*\r\n\r\n")
    --conn:on("receive", function(conn, payload)
    --    print("Response: \r\n")
    --    print(payload)
    --    print("end response\r\n")
    --end)
    --conn:on("disconnection", function(conn) 
     --   print("Disconnected")
        if doSleep == true then
            print("Will sleep")
            gotoSleepAfterMs(2000, 60)
        end
        print("wont sleep")
    --end)
end
