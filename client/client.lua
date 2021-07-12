local modules = peripheral.getNames()
local modem

local port = 65088
local reply = 65087

local arguments = {...}
local file = arguments[1]
local server = arguments[2]

for _,name in pairs(modules) do
	if peripheral.getType(name) == "modem" then
		if peripheral.call(name,"isWireless") then
			modem = peripheral.wrap(name)
			break
		end
	end
end

assert(modem,"No modem.")
assert(file,"No file.")
assert(server,"No server address.")

local input = io.open(file,"r")

local content = {}
local out = {}

for line in input:lines() do
	table.insert(content,line)
end

out[1] = server
out[2] = file
out[3] = table.concat(content)

modem.transmit(port,reply,out)
print("Sent")
