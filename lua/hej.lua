function hej()
    
    s, t, h = rdTemp(2)
    --print(s)
    
    local tRem = t % 10
    --print("Temperatur: "..((t-tRem) / 10).."."..tRem.." grader C")
    print(string.format("Temperatur: %i.%i grader C", (t-tRem)/10, tRem))

    
    local hRem = h % 10
    print(string.format("Relativ Luftfuktighet: %i.%i%%", (h-hRem)/10, hRem))

    s = string.format("test?temp=%i.%i&hum=%i.%i", (t-tRem)/10, tRem, (h-hRem)/10, hRem)
    pushData(s)
end

function pushData(filename)

    print(filename)
    port, path = 80, "/esp8266/data"
    
    server = "192.168.1.78"
    conn = net.createConnection(net.TCP, false)
    conn:connect(80,server)
    conn:send("GET "..path.."/"..filename.." HTTP/1.0\r\n".."Host: "..server.."\r\nConnection: close\r\nAccept: */*\r\n\r\n")
    conn:on("receive", function(conn, payload)
        print("Response: \r\n")
        print(payload)
        print("end response\r\n")
    end)
    conn:on("disconnection", function(conn) 
        print("Disconnected")
    end)
end

function log()
    tmr.alarm(1, 10000, 1, hej)
end