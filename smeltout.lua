-- now that i think about it, this is basically just pipe but using config server

-- get config
peripheral.find("modem",rednet.open)
rednet.host("config","smeltout"..math.random())
local consvr = rednet.lookup("config","config")
rednet.send(consvr,nil,"config")
local _,config = rednet.receive("config")
rednet.unhost("config")
rednet.close()
-- env
local furnaces = config.storage.smelting.copper.furnaces
local output = config.storage.smelting.copper.output

while true do
    for i,id in pairs(furnaces) do
        local furnace = peripheral.wrap("minecraft:furnace_"..id)
        furnace.pushItems(output,3)
    end
end
