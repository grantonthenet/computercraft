-- returns to home location
-- set in shell using `set home x,y,z,dir`
local flop = {
    north = 1,
    east = 2,
    south = 3,
    west = 4,
    [1] = "north",
    [2] = "east",
    [3] = "south",
    [4] = "west"
}
local function getFacing()
    local p1 = {gps.locate()}
    local fwd = 0
    if turtle.forward() then
        fwd = 1
    else turtle.back() end
    local p2 = {gps.locate()}
    if fwd == 1 then
        turtle.back()
    else turtle.forward() end
    if p1[1] ~= p2[1] then
        if p2[1] > p1[1] and fwd == 1 then
            return "east"
        elseif p2[1] < p1[1] and fwd == 0 then
            return "east"
        else return "west" end
    else
        if p2[3] > p1[3] and fwd == 1 then
            return "south"
        elseif p2[3] < p1[3] and fwd == 0 then
            return "south"
        else return "north" end
    end
    return "idk"
end
local facing = getFacing()

local function face(to)
    local to_n = to
    if type(to) == "string" then
        to_n = flop[to]
    end
    local fc_n = facing
    if type(facing) == "string" then
        fc_n = flop[facing]
    end
    print(fc_n.." to "..to_n)
    if to_n > fc_n then
        print("gt")
        for i=1,to_n-fc_n do
            turtle.turnRight()
        end
    elseif to_n < fc_n then
        print("lt")
        for i=1,fc_n-to_n do
            turtle.turnLeft()
        end
    end
    facing = flop[to_n]
end

local function getHome()
    local h_s = settings.get("home")
    local h = {}
    for m in h_s:gmatch("%d+") do
        table.insert(h,tonumber(m))
    end
    return h
end

local function goHome()
    local home = getHome()
    local cpos = {gps.locate()}
    if cpos[1] < home[1] then
        face("east")
        for i=1,home[1]-cpos[1] do
            turtle.forward()
        end
    elseif cpos[1] > home[1] then
        face("west")
        for i=1,cpos[1]-home[1] do
            turtle.forward()
        end
    end
    if cpos[3] < home[3] then
        face("south")
        for i=1,home[3]-cpos[3] do
            turtle.forward()
        end
    elseif cpos[3] > home[3] then
        face("north")
        for i=1,cpos[3]-home[3] do
            turtle.forward()
        end
    end
    face(home[4])
end
goHome()
