local modules = peripheral.getNames()

for k,v in pairs(modules) do
	print(k,v)
end