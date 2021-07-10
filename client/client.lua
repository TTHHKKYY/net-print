local modules = peripheral.getNames()
local modem

local arguments = {...}
local file = arguments[1]

for _,name in pairs(modules) do
	if string.match(name,"modem") then
		if peripheral.call(name,"isWireless") then
			modem = peripheral.wrap(name)
			break
		end
	end
end

assert(modem,"No modem.")
assert(file,"No file.")

local port = 65088
local reply = 65087

local input = io.open(file,"r")

local content = {}
local out = {}

for line in input:lines() do
	table.insert(content,line)
end

out[1] = file
out[2] = table.concat(content)

modem.transmit(port,reply,out)
print("Sent")
