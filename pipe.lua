-- moves items from multiple source inventories to one destination
local sources = {
    "minecraft:barrel_197",
    "minecraft:barrel_198",
    "minecraft:barrel_199",
    "minecraft:barrel_200",    
}
local dst = "sc-goodies:iron_barrel_125"

while true do
    os.queueEvent("pipe")
    os.pullEvent("pipe")
    -- go through sources
    for si=1,#sources do
        -- wrap source, list items
        local s = peripheral.wrap(sources[si])
        local l = s.list()
        -- move items to destination
        for ii=1,#l do
            -- move if item in slot
            if l[ii] then
                s.pushItems(dst,ii)
            end
        end
    end
end
