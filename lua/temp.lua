t = require("ds18b20")

GPIO4  = 2
GPIO13 = 7

t.setup(GPIO4)
addrs = t.addrs()
if (addrs ~= nil) then
  print("Total DS18B20 sensors: "..table.getn(addrs))
end

-- Just read temperature
print("Temperature: "..t.read().."'C")

-- Don't forget to release it after use
t = nil
ds18b20 = nil
package.loaded["ds18b20"]=nil
