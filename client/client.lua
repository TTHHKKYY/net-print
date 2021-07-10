local modem = peripheral.find("modem")

local arguments = {...}
local file = arguments[1]

assert(modem,"No modem.")
assert(modem.isWireless(),"Modem is not rednet capable.")
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
