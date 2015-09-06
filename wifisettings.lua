--AP mode for settings, Tai-Hsien Ouyang, 2015
wifi.setmode(wifi.SOFTAP);	
config={};
config.ssid="RC_AP";		--SSID of the soft AP
config.pwd="QWERT123";			--Password of the soft AP
wifi.ap.config(config);
print(wifi.ap.getip());
--require("config.lua"); --read the variables: SSID, PWD
srv=net.createServer(net.TCP);
srv:listen(80,function(conn)
      conn:on("receive",function(client,request)
      local buf = "";
      parsePost_SSID={string.find(request,"SSID=")};	--parse the packet
      parsePost_PWD={string.find(request,"password=")};
        if parsePost_SSID[2]~=nil then
            SSID_print='SSID='..'"'..string.sub(request,parsePost_SSID[2]+1,#request)..'"';
            SSID=string.sub(request,parsePost_SSID[2]+1,#request);
            print(SSID_print);
            PWD_print='password='..'"'..string.sub(request,parsePost_PWD[2]+1,#request)..'"';
            PWD=string.sub(request,parsePost_PWD[2]+1,#request) ;   
            file.open("config.lua","w+");
            file.writeline(SSID);
            file.writeline(PWD);
            file.close();
        end
        print('OK')
        buf = buf.."HTTP/1.1 200 OK\n\n";
        buf = buf.."<html><head></head><body><h1>WiFi Configuration</h1>";
        buf = buf.."<form action=\"\" method=\"POST\">";
		buf = buf.."<p>SSID of the AP: <input type=\"text\" name=\"SSID\"></p>"
		buf = buf.."<p>Password of the AP: <input type=\"text\" name=\"password\"></p>"
        buf = buf.."<input type=\"submit\" value=\"Submit\">";
        buf = buf.."<p>Tai-Hsien Ouyang, 2015</p></form></body></html>";
        client:send(buf);
        client:close();
        collectgarbage();
	end)
end)
