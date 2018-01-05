
function rdTemp(pin)
  
  local humidity
  local temperature

  local checksum
  local checksumTest
  humidity = 0
  temperature = 0
  checksum = 0

  -- Use Markus Gritsch trick to speed up read/write on GPIO
  local gpio_read = gpio.read
  local dbgStream = {}
  local bitStream = {}
  local bitStreamLow = {}
  for j = 1, 40, 1 do
    bitStream[j] = 0
    bitStreamLow[j] = 0
  end

  for j = 1, 10, 1 do
    dbgStream[j] = 0
  end

  local bitlength = 0
  local l = 0
  -- Step 1:  send out start signal to DHT22
  gpio.mode(pin, gpio.OUTPUT)
  gpio.write(pin, gpio.HIGH)
  tmr.delay(150)
  gpio.write(pin, gpio.LOW)
  tmr.delay(240)
  --delayMicroseconds(40)
  --gpio.write(pin, gpio.HIGH)
  gpio.mode(pin, gpio.INPUT)
  --debug1 = gpio_read(2)

  -- Step 2:  DHT22 send response signal 
  -- bus will always let up eventually, don't bother with timeout
  
  -- Tbe, low (remaining from driving it low)
  while (gpio_read(pin) == 0 ) do l = l + 1 end
  dbgStream[0] = l
  
  -- Tgo, high
  local c=0
  while (gpio_read(pin) == 1 and c < 500) do c = c + 1 end
  dbgStream[1] = c
  -- bus will always let up eventually, don't bother with timeout

  -- Trel, low
  l = 0
  while (gpio_read(pin) == 0 ) do l = l + 1 end
  dbgStream[2] = l

  -- Treh, high
  c=0
  while (gpio_read(pin) == 1 and c < 500) do c = c + 1 end
  dbgStream[3] = c


  -- Step 3: DHT22 send data
  
  for j = 1, 40, 1 do
    l = 0
    while (gpio_read(pin) == 0) do l = l + 1 end
    bitStreamLow[j] = l
    c = 0
    while (gpio_read(pin) == 1 and c < 50 ) do c = c + 1 end
    bitStream[j] = c
  end


  -- print out result
--  for j = 1, 40, 1 do
--    for i = 1, bitStreamLow[j], 1 do
--      print("0")
--    end
--    for i = 1, bitStream[j], 1 do
--      print("1")
--    end
--    print(" ")
--  end

--  print("\n")
--  print("low high\n")
--  for j = 1, 40, 1 do
--    print(j .. ": " .. bitStreamLow[j] .. " " .. bitStream[j] .. "\n")
--  end

  print("\n")
  print("debug: "..dbgStream[0] .. " " ..dbgStream[1] .. " " ..dbgStream[2] .. " " ..dbgStream[3] .. "\n")
  

  
  
  --DHT data acquired, process.
  for i = 1, 16, 1 do
    --print("HumHigh["..i.."]: "..bitStream[i])
    if (bitStream[i] >= 4) then
      humidity = humidity + 2 ^ (16 - i)
    end
  end
  for i = 1, 16, 1 do
    --print("TmpHigh["..i.."]: "..bitStream[i+16])
    if (bitStream[i + 16] >= 4) then
      temperature = temperature + 2 ^ (16 - i)
    end
  end
  for i = 1, 8, 1 do
      --print("ChkHigh["..i.."]: "..bitStream[i+32])

    if (bitStream[i + 32] >= 4) then
      checksum = checksum + 2 ^ (8 - i)
    end
  end

  checksumTest = (bit.band(humidity, 0xFF) + bit.rshift(humidity, 8) + bit.band(temperature, 0xFF) + bit.rshift(temperature, 8))
  checksumTest = bit.band(checksumTest, 0xFF)
  --print("chk: "..checksum ..", test: "..checksumTest)
  
  --print("Datum och tid: TBD")
  --h = humidity
  --print("Relativ Luftfuktighet: "..((h-(h % 10)) / 10).."."..(h % 10).."%")
  if temperature > 0x8000 then
    -- convert to negative format
    temperature = -(temperature - 0x8000)
  end
  --t = temperature
  --print("Temperatur: "..((t-(t % 10)) / 10).."."..(t % 10).." grader C")
  --print(string.format("Temperatur: %i", temperature))

  local sucess = 1
  
  -- conditions compatible con float point and integer
  if (checksumTest - checksum >= 1) or (checksum - checksumTest >= 1) then
    print("ERROR! Checksum test failed!\n")
    print(string.format("checksum: 0x%X, test: 0x%X", checksum, checksumTest))
    print(string.format("hum: 0x%X", humidity))
    print(string.format("temp: 0x%X", temperature))
    sucess = 0
  end
  --Per DHT Arduino Lib
  gpio.mode(pin, gpio.OUTPUT)
  gpio.write(pin, gpio.HIGH)
  return sucess, temperature, humidity
end

