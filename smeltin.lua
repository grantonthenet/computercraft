-- takes items from inventory, spreads them to 8 furnaces
-- adding more than 8 furnaces will do nothing

-- get config
peripheral.find("modem",rednet.open)
rednet.host("config","smeltin"..math.random())
local consvr = rednet.lookup("config","config")
rednet.send(consvr,nil,"config")
local _,config = rednet.receive("config")
rednet.unhost("config")
rednet.close()
-- env
local furnaces = config.storage.smelting.copper.furnaces
local input = peripheral.wrap(config.storage.smelting.copper.input)
local coal = config.storage.coal

local function findOccupied(p)
    local inv = peripheral.wrap(p)
    local ilist = inv.list()
    for i=1,#ilist do
        if ilist[i] then return i end
    end
end

while true do
    local list = input.list()
    if #list > 0 then
        for slot,stack in pairs(list) do
            if stack.count > 7 then
                for i=1,math.floor(stack.count/8) do
                    local furnace = peripheral.wrap("minecraft:furnace_"..furnaces[i])
                    local flist = furnace.list()
                    if not flist[1] or flist[1].count <= 56 then
                        furnace.pullItems(peripheral.getName(input),slot,8,1)
                        furnace.pullItems(coal,findOccupied(coal),1,2)
                    end
                end
            end
        end
    else sleep(0) end
end
