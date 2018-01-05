ip, mask, host = wifi.sta.getip()
port, path, pgm = 80, "/esp8266/upload", "u.lua"
server = "192.168.1.78"
file.remove(pgm) ; file.open(pgm, "w+") payloadFound = false
conn = net.createConnection(net.TCP, false)
conn:connect(80,server)
conn:send("GET "..path.."/"..pgm.." HTTP/1.0\r\n".."Host: "..server.."\r\nConnection: close\r\nAccept: */*\r\n\r\n")
conn:on("receive", function(conn, payload)
        --print("Response: \r\n")
        --print(payload)
        --print("end response\r\n")
        if (payloadFound) then 
            file.write(payload) file.flush()
        else 
            payloadOffset = string.find(payload, "\r\n\r\n")
            if (payloadOffset) then
                file.write(string.sub(payload, payloadOffset + 4)) file.flush() payloadFound = true
            end
        end
    end)
conn:on("disconnection", function(conn) 
        file.close()
        dofile(pgm)
    end)
