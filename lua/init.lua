
t = 0
retval = false

function log()
    print("log")
end

-- connect to Wifi network
function connWifi(ssid, pwd, timeout)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid, pwd)

    t = 0
    retval = false

    tmr.alarm(0, 1000, 1, function()
        if wifi.sta.getip() == nil then
            if t < timeout then
                print("Connecting to AP...")
                t = t + 1
            else
                tmr.stop(0)
                print(t..'s timeout. Connection to '..ssid..' failed\n')
            end
        else
            print('Connected to '..ssid..', IP: '..wifi.sta.getip()..'\n')
            retval = true
            tmr.stop(0)
            if doLog == true then
                dofile("mqtt_hum.lua")
                log(true) -- only log data if/when connection sucessful
            end
            if doWater == true then
                dofile("mqtt.lua")
            end
        end
    end)
end


function abortInit()
  -- initailize abort boolean flag
  abort = false
  doLog = true
  doWater = false
  print("Press ENTER to abort startup")
  -- if <CR> is pressed, call abortTest
  uart.on("data", "\r", abortTest, 0)
  -- start timer to execute startup function in 5 seconds
  tmr.alarm(0,5000,0,startup)
end

function abortTest(data)
  -- user requested abort
  abort = true
  doLog = false
  doWater = false
  -- turns off uart scanning
  uart.on("data")
end

function startup()
  uart.on("data")
  -- if user requested abort, exit
  if abort == true then
    print("startup aborted")
    return
  end
  -- otherwise, start up
  print("in startup")
  dofile("wifi.lua")
  --dofile("bc.lua")
  dofile("rdtemp.lua")
  dofile("pushdata.lua")
  dofile("stats.lua")
  dofile("log.lua")
  node.setcpufreq(node.CPU160MHZ)
  --dofile("telnet_server.lua")
  --setupTelnetServer()
  
    print("Startup completed")
end

--dofile("pulseCnt.lua")
--pump(0)
abortInit()

