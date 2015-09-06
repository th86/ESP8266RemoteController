--ESP8266-based Remote Controller, Tai-Hsien Ouyang, 2015
isNormalMode=1;
gpio.mode(7, gpio.INPUT, gpio.PULLUP); --must pull-up the pin for reading!

print('Wait 2 sec for updates')

function sysinit()
    isNormalMode=tonumber(gpio.read(7));
    print(isNormalMode);
    if(isNormalMode==1)then
        print("normal mode...");
        collectgarbage();
        dofile('controller.lua');
    else
        print("WiFi configuration mode");
        collectgarbage();
        dofile('wifisettings.lua');
    end
end
tmr.alarm(0,2000,0,sysinit); --must be more than 2 sec
  