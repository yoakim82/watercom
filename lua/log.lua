n = 3
temp = {}
hum = {}


function log(doSleep)
    tmr.alarm(2, 500, 1, function()
        print(n .. "tries left")
        
        s, t, h = rdTemp(2)
        if s == 1 then
            temp[n] = t
            hum[n] = h
            n = n - 1
        end
        

        if n == 0 then
            tmr.stop(2)
        
            -- find median values
            t = median(temp)
            h = median(hum)
            local tRem = t % 10
            --print("Temperatur: "..((t-tRem) / 10).."."..tRem.." grader C")
            print(string.format("Temperatur: %i.%i grader C", (t-tRem)/10, tRem))
           
            local hRem = h % 10
            print(string.format("Relativ Luftfuktighet: %i.%i%%", (h-hRem)/10, hRem))
            s = string.format("test.php?temp=%i.%i&hum=%i.%i", (t-tRem)/10, tRem, (h-hRem)/10, hRem)
        
            -- push data to db
            pushData(s, doSleep)
        end        
    end)    
    
end

-- Reads temp n times and stores result in array
function getTemp()
    
   
    --pushData(s, doSleep)
    
end

--function log()

--    for j = 1, n, 1 do
--        s, t, h = rdTemp(2)
--        if s == 1 then
--            temp[j] = t
--            hum[j] = h
--        end
--        tmr.delay(500000)
--    end
--    t = median(temp)
--   h = median(hum)
--    local tRem = t % 10
--    --print("Temperatur: "..((t-tRem) / 10).."."..tRem.." grader C")
--    print(string.format("Temperatur: %i.%i grader C", (t-tRem)/10, tRem))
--   
--    local hRem = h % 10
--    print(string.format("Relativ Luftfuktighet: %i.%i%%", (h-hRem)/10, hRem))
--    s = string.format("test.php?temp=%i.%i&hum=%i.%i", (t-tRem)/10, tRem, (h-hRem)/10, hRem)
--    return s
--    --pushData(s, doSleep)
    
--end

function gotoSleepAfterMs(ms, wakeupAfterS)


    tmr.alarm(2,ms,0, function()
        node.dsleep(wakeupAfterS*1000*1000)
    end)
end

    