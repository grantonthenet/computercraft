dofile("/config.lua")
peripheral.find("modem",rednet.open)
rednet.host("config","config")

while true do
    local id,msg = rednet.receive("config")
    rednet.send(id,config,"config")
end
