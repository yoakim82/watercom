pulseCnt = 0
dlitersCnt = 0
accWaterCnt = 0
updateCnt = 0
startTime = 0

-- myInterrupt:  called every time an event occurs
function myInterrupt() 
    pulseCnt = pulseCnt + 1
end

GPIO12 = 6
pulsePin = GPIO12

GPIO14 = 5
outPin = GPIO14

pulse = 0
prevPulse = 0
waterFlow = 0.0;

-- measures flow and disengages pump after set num of liters
function measFlow()
  
  -- set Pin 2 generate an interrupt on high-to-low transitions
  -- and attach myInterrupt() to the interrupt

  gpio.mode(pulsePin,gpio.INT)
  gpio.trig(pulsePin, "down", myInterrupt)

  -- display counter value every second.
  tmr.alarm(1, 100, 1, updateFlow)
end
  
function updateFlow()
  updateCnt = updateCnt + 1
  pulse = pulseCnt 
  waterFlow = (10*(pulse - prevPulse)) / 7.5 -- in liters / 10 min
  dlitersCnt = pulseCnt / 45
  local wRem = waterFlow % 10
  prevPulse = pulse
  elapsedTime = (tmr.now() - startTime) / 1000000
  if (updateCnt % 5) == 0 then  
    print(string.format("time %i s, pulse %i: %i.%i l/min, tot: %i dl\n", elapsedTime, pulse, (waterFlow-wRem)/10, waterFlow, dlitersCnt))    
    --ret = sendValuesToDB(pulse, waterflow, 0);
  end
end

function pump(on)
    if on > 0 then
        gpio.mode(outPin,gpio.OUTPUT)
        -- engage water pump
        gpio.write(outPin,gpio.HIGH)
        startTime = tmr.now()
    else
        gpio.mode(outPin,gpio.OUTPUT)
        -- disengage water pump
        gpio.write(outPin,gpio.LOW)    
    end
end

function off()
    pump(0)
    tmr.stop(1)
    tmr.stop(2)
end

function waterPlants(dliters)
  if dliters > 0 then
    -- engage water pump
    pump(1)
    measFlow()
    tmr.alarm(2, 100, 1, function()
        monitorAccWater(dliters)
    end)

  end
end

function w1(dliters)
    waterPlants(dliters)
end

function w2(seconds)
    
    pump(1)
    measFlow()
    tmr.alarm(2, 200, 1, function()
        monitorTime(seconds)
    end)
end


function monitorAccWater(dliters)
  if dlitersCnt >= dliters then
    
    -- disengage pump
    pump(0)
 
    -- stop generating interrupts
    gpio.trig(pulsePin, "none")  

    -- stop update measurements
    tmr.stop(1)

    -- kill this monitoring
    tmr.stop(2)

    -- reset water counter
    accWaterCnt = accWaterCnt + dlitersCnt
    dlitersCnt = 0
    pulseCnt = 0
    prevPulse = 0
    updateCnt = 0
  end
end


function monitorTime(seconds)
  if (tmr.now() - startTime) >= (seconds * 1000000) then
    
    -- disengage pump
    pump(0)
 
    -- stop generating interrupts
    gpio.trig(pulsePin, "none")  

    -- stop update measurements
    tmr.stop(1)

    -- kill this monitoring
    tmr.stop(2)

    -- reset water counter
    accWaterCnt = accWaterCnt + dlitersCnt
    dlitersCnt = 0
    pulseCnt = 0
    prevPulse = 0
    updateCnt = 0
    startTime = 0
  end
  m:publish("stat/vattenkanna/result", tostring(accWaterCnt), 0, 0)
end  

