local modules = peripheral.getNames()
local modem

local port = 65088
local reply = 65087

local arguments = {...}
local server = arguments[1]
local file = arguments[2]

for _,name in pairs(modules) do
	if peripheral.getType(name) == "modem" then
		if peripheral.call(name,"isWireless") then
			modem = peripheral.wrap(name)
			break
		end
	end
end

assert(modem,"No wireless modem.")
assert(server,"No server address.")
assert(file,"No file.")

local input = io.open(file,"r")

local content = {}
local out = {}

for line in input:lines() do
	table.insert(content,line)
end

out[1] = server
out[2] = file
out[3] = table.concat(content,"\n")

modem.transmit(port,reply,out)
print("Sent")
