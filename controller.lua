--ESP8266 Remote Controller Tai-Hsien Ouyang, 2015
print('Initializing WiFi...');
require("config");
wifi.setmode(wifi.STATION);
wifi.sta.config(SSID,PWD);
print(wifi.sta.getip());
print('Initializing IO...');
M1A=3;M1B=4;M2A=5;M2B=6;servo1=1;servo2=2;sensor=7;--3=GPIO0,LED
gpio.mode(M1A, gpio.OUTPUT);gpio.mode(M1B, gpio.OUTPUT);gpio.mode(M2A, gpio.OUTPUT);gpio.mode(M2B, gpio.OUTPUT);gpio.mode(sensor, gpio.INPUT, gpio.PULLUP);
pwm.setup(servo1, 50, 74);pwm.setup(servo2, 50, 74);
pwm.start(servo1);pwm.start(servo2); 
adc_id = 0;
collectgarbage(); --must collect garbage or the HTTP function will run out of the memory
srv=net.createServer(net.TCP);
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end 
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end   
        end    
        if(_GET.pin == "FW1")then
              gpio.write(M1A, gpio.HIGH);
              gpio.write(M1B, gpio.LOW);
        elseif(_GET.pin == "ST1")then
              gpio.write(M1A, gpio.LOW);
              gpio.write(M1B, gpio.LOW);
        elseif(_GET.pin == "RV1")then
              gpio.write(M1A, gpio.LOW);
              gpio.write(M1B, gpio.HIGH);
        elseif(_GET.pin == "FW2")then
              gpio.write(M2A, gpio.HIGH);
              gpio.write(M2B, gpio.LOW);
        elseif(_GET.pin == "ST2")then
              gpio.write(M2A, gpio.LOW);
              gpio.write(M2B, gpio.LOW);
        elseif(_GET.pin == "RV2")then
              gpio.write(M2A, gpio.LOW);
              gpio.write(M2B, gpio.HIGH);
        elseif(_GET.pin == "PaZ")then
              pwm.setduty(servo1, 74);
        elseif(_GET.pin == "Pa2")then
              pwm.setduty(servo1, 54);
        elseif(_GET.pin == "Pa3")then
              pwm.setduty(servo1, 94);
        elseif(_GET.pin == "PbZ")then
              pwm.setduty(servo2, 74);
        elseif(_GET.pin == "Pb2")then
              pwm.setduty(servo2, 54);
        elseif(_GET.pin == "Pb3")then
              pwm.setduty(servo2, 94);                 
        --elseif(_GET.pin == "RST")then
        --        node.restart();
        end
        print('OK');
        buf = buf.."HTTP/1.1 200 OK\n\n";
        buf = buf.."<html><body><h1>Web-Based Controller</h1>";
        buf = buf.."<p>IP="..wifi.sta.getip().."</p>";
        buf = buf.."<p>Switch State="..gpio.read(sensor)..", ADC Read="..adc.read(adc_id).."</p>";
        buf = buf.."<p>Motor1<a href=\"?pin=FW1\"><button>FWD</button></a><a href=\"?pin=ST1\"><button>STP</button></a><a href=\"?pin=RV1\"><button>REV</button></a></p>";
        buf = buf.."<p>Motor2<a href=\"?pin=FW2\"><button>FWD</button></a><a href=\"?pin=ST2\"><button>STP</button></a><a href=\"?pin=RV2\"><button>REV</button></a></p>";
        buf = buf.."<p>Servo1<a href=\"?pin=Pa2\"><button>A</button></a><a href=\"?pin=PaZ\"><button>0</button></a><a href=\"?pin=Pa3\"><button>B</button></a></p>";
        buf = buf.."<p>Servo2<a href=\"?pin=Pb2\"><button>A</button></a><a href=\"?pin=PbZ\"><button>0</button></a><a href=\"?pin=Pb3\"><button>B</button></a></p>";
       --buf = buf.."<p>Restart <a href=\"?pin=RST\"><button>Restart</button></a></p>";
        buf = buf.."<p>Taihsien Ouyang</p></body></html>";
        print(node.heap())
        client:send(buf); --WATCHOUT! Cannot be too long.
        client:close();
        collectgarbage();
    end)
end)