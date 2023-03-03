-- this one requires sc-peripherals, which is a switchcraft thing (sc3.io)
local chest = peripheral.wrap("ender_storage_6203")
local monitor = peripheral.wrap("left")
monitor.setTextScale(0.5)
monitor.clear()

local favorites = {
    ["Lava"] = {2,2,2},
    ["Lava Return"] = {2,2,1},
    ["Snow Balls"] = {1,4,1},
    ["Waste"] = {15,15,15},
    ["Rocks"] = {8,8,8},
}
local fkeys = {}
for k,v in pairs(favorites) do
    table.insert(fkeys,k)
end

local selection = 2
local channel = {1,1,1}
local chs = {"l","m","r"}
local tcol = {
    colors.white,
    colors.orange,
    colors.magenta,
    colors.lightBlue,
    colors.yellow,
    colors.lime,
    colors.pink,
    colors.gray,
    colors.lightGray,
    colors.cyan,
    colors.purple,
    colors.blue,
    colors.brown,
    colors.green,
    colors.red,
    colors.black
}

local function text(x,y,txt,color)
    monitor.setCursorPos(x,y)
    if not color then color = colors.white end
    monitor.setTextColor(color)
    monitor.write(txt)
end
local function rect(x,y,w,h,color,highlight)
    local bg = colors.toBlit(color)
    local fg = bg
    if highlight then
        if bg == "0" then
            fg = "f"
        else
            fg = "0" -- white
        end
    end
    for i=x,x+w do
        for j=y,y+h do
            monitor.setCursorPos(i,j)
            monitor.blit("\127",fg,bg)
        end
    end
end

local selectionModified = true
local showFavs = false
parallel.waitForAny(function() while true do
    -- drawing
    if selectionModified then
        selectionModified = false
        -- ok a little updating because stuff
        chest.setFrequency(tcol[channel[1]],
                           tcol[channel[2]],
                           tcol[channel[3]])
        monitor.clear()
        if showFavs then
            -- favorites
            for i=1,#fkeys do
                text(1,i,fkeys[i])
            end
        else
            -- top
        for i=1,3 do
            local basex = (i*5)-4
            local col = tcol[channel[i]]
            if selection == i then
                text(basex,1," >"..chs[i].."< ",col)
            else
                text(basex,1,"  "..chs[i].."  ",col)
            end
        end
        local opt = channel[selection]
        for i=1,15 do
            rect(i,2,1,12,tcol[i],opt==i)
        end
        rect(1,10,15,1,tcol[16],opt==16)
        text(15,10,"F",colors.white)
        end
        -- lower
    else sleep(0) end
end end, function() while true do
    -- handle input
    local e,s,x,y = os.pullEvent("monitor_touch")
    if showFavs then
        if y <= #fkeys then
            showFavs = false
            channel = favorites[fkeys[y]]
        end
    elseif y > 1 and y < 10 then
        channel[selection] = x
    elseif y == 10 then
        if x < 14 then
            channel[selection] = 16
        else
            showFavs = true
        end
    else
        if     x <= 5  then selection = 1
        elseif x <= 10 then selection = 2
        elseif x <= 15 then selection = 3
        end
    end
    selectionModified = true
end end)
