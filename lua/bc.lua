-- basic commands

function ls()
    for k,v in pairs(file.list()) do print(k.." ("..v.." bytes)") end
end

function readFile(path)
    file.open(path, "r") -- r read mode and b binary mode
    local content = file:read "*a" -- *a or *all reads the whole file
    print(content)
    file:close()
end

function getFile(filename)
    
    port, path = 80, "/esp8266/upload"
    server = "192.168.1.78"
    file.remove(filename) ; file.open(filename, "w+") payloadFound = false
    conn = net.createConnection(net.TCP, false)
    conn:connect(80,server)
    conn:send("GET "..path.."/"..filename.." HTTP/1.0\r\n".."Host: "..server.."\r\nConnection: close\r\nAccept: */*\r\n\r\n")
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
    end)
end

--function tmp(pin)

--    dht22= require("dht_jl")
--    local t
--    local h
    
--    sucess = dht22.read(pin)
--    if (sucess) then
--        t = dht22.getTemperature()
--        h = dht22.getHumidity()
--        print("Relativ Luftfuktighet: "..((h-(h % 10)) / 10).."."..(h % 10).."%")
--        print("Temperatur: "..((t-(t % 10)) / 10).."."..(t % 10).." grader C")
--    else
--        print("Error trying to read sensor\n")
--    end
    
    -- release module
--    dht22 = nil
--    package.loaded["dht22_jl"]=nil
--end
