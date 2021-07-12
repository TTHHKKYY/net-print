local modules = peripheral.getNames()
local printer
local modem

local host = os.getComputerID()

local incoming = 65088
local reply = 65087

for _,name in pairs(modules) do
	if peripheral.getType(name) == "modem" then
		if peripheral.call(name,"isWireless") then
			modem = peripheral.wrap(name)
			break
		end
	end
end

for _,name in pairs(modules) do
	if peripheral.getType(name) == "printer" then
		printer = peripheral.wrap(name)
		break
	end
end

assert(printer,"No printer.")
assert(modem,"No wireless modem.")

modem.open(incoming)
modem.open(reply)

while true do
	local event,_,port,_,data = os.pullEventRaw()
	
	if event == "terminate" then
		modem.close(incoming)
		modem.close(reply)
		print("Stopped Server")
		return
	end
	if event == "modem_message" and port == incoming then
		local server = data[1]
		local name = data[2]
		local content = data[3]
		
		if server == host then
			printer.newPage()
			printer.setPageTitle()
			print("Printing...")
			
			for i=1,#content do
				if i % printer.getPageSize() == 0 then
					if printer.getPaperLevel() == 0 then
						print("Ran out of paper.")
						break
					end
					
					printer.newPage()
					printer.setPageTitle(name)
				end
				if printer.getInkLevel() == 0 then
					print("Ran out of dye.")
					break
				end
				
				printer.write(string.sub(content,i,i))
			end
			
			printer.endPage()
			print("Done")
		end
	end
end
