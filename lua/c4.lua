function c4()

    GPIO4  = 2
    GPIO13 = 7
    GPIO12 = 6
    
    outPin = GPIO13
    inPin = GPIO12
    IN_CAP_TO_GND = 30
    MAX_ADC_VALUE = 1023; -- 1023 * 3.3, max value if 3.3 V could be sensed
  
    tmr.delay(1000)
    time = 0    
    print("ADC before timing start: ", adc.read(0))
    
    --gpio.mode(inPin,gpio.INPUT,gpio.FLOAT)
    --print("ADC after float: ", adc.read(0))
    gpio.write(outPin,gpio.HIGH)


    start = tmr.now()
    --time = start
    
--    while(adc.read(0) < 1022)
--    do
--        time = tmr.now() - start
--        print('Value: '..adc.read(0)..', time: '..time..'\r')
--    end
    time = tmr.now() - start
    print('Value: '..adc.read(0)..', time: '..time..'\r')
        
    gpio.mode(outPin,gpio.OUTPUT)
    --gpio.mode(inPin,gpio.OUTPUT)
    
    --gpio.write(inPin,gpio.LOW)
    gpio.write(outPin,gpio.LOW)
end
