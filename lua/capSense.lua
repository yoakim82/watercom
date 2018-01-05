function cap(n)

    
    GPIO4  = 2
    GPIO13 = 7
    GPIO12 = 6
    
    outPin = GPIO13
    inPin = GPIO12
    IN_CAP_TO_GND = 30
    MAX_ADC_VALUE = 1023; -- 1023 * 3.3, max value if 3.3 V could be sensed
    
    gpio.mode(outPin,gpio.OUTPUT)
    gpio.mode(inPin,gpio.OUTPUT)
    
    gpio.write(inPin,gpio.LOW)
    gpio.write(outPin,gpio.LOW)
    
    print("ADC first: ", adc.read(0))
    
    gpio.mode(inPin,gpio.INPUT,gpio.FLOAT)
    
    print("ADC before: ", adc.read(0))
    
    gpio.write(outPin,gpio.HIGH)
    val = adc.read(0)
    print("ADC first after: ", val)
    tmr.delay(10000);

    adc_ary = {};

    for i = 1,n,1 do
        if (i % 10 == 0) then
            adc_ary[i] = adc.read(0)
            print("ADC after: ", adc_ary[i])
        end
        tmr.delay(10000);
    end
    
    --val = adc_ary[0]; --median(adc_ary);
    print("ADC median: ", val)
    
    capacitance = val * IN_CAP_TO_GND / (MAX_ADC_VALUE - val);
    
    print("Capacitance: ", capacitance)
    
    --gpio.write(outPin,gpio.LOW)
    
    --gpio.mode(inPin,gpio.OUTPUT)
    --gpio.write(inPin,gpio.LOW)
    
    val2 = adc.read(0)
    print("ADC last: ", val2)
end

--cap()

function c3()

     tmr.alarm(1, 2000, 1, function()
        c2()
     end)
end

function c2()

    GPIO4  = 2
    GPIO13 = 7
    GPIO12 = 6
    
    outPin = GPIO13
    inPin = GPIO12
    IN_CAP_TO_GND = 30
    MAX_ADC_VALUE = 1023; -- 1023 * 3.3, max value if 3.3 V could be sensed
  
    tmr.delay(1000)
    
    print("ADC before timing start: ", adc.read(0))
    
    gpio.mode(inPin,gpio.INPUT,gpio.FLOAT)
    gpio.write(outPin,gpio.HIGH)


    start = tmr.now()
    time = start
    
    tmr.alarm(0, 1, 1, function()
        val = adc.read(0)
        --val = gpio.read(inPin)
        if val < 1022 then
            time = tmr.now() - start
            print('Value: '..val..', time: '..time..'\r')
                
        else
            time = tmr.now() - start
            tmr.stop(0)
            print(time..' elapsed\n')
            print('inPin: '..gpio.read(inPin)..'\n')
            retval = true
            tmr.stop(0)
            gpio.mode(outPin,gpio.OUTPUT)
            gpio.mode(inPin,gpio.OUTPUT)
    
            gpio.write(inPin,gpio.LOW)
            gpio.write(outPin,gpio.LOW)

        end
    end)
    
end
