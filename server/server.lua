local modules = peripheral.getNames()
local printer,modem

local incoming = 65088
local reply = 65087

for _,name in pairs(modules) do
	if string.match(name,"modem") then
		if peripheral.call(name,"isWireless") then
			modem = peripheral.wrap(name)
			break
		end
	end
end

for _,name in pairs(modules) do
	if string.match(name,"printer") then
		printer = peripheral.wrap(name)
	end
end

assert(printer,"No printer.")
assert(modem,"No modem.")

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
		local name = data[1]
		local content = data[2]
		
		printer.newPage()
		printer.setPageTitle(name)
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
		end
		
		printer.endPage()
		print("Done")
	end
end
