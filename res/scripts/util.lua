-- Util object
local lib = {
}

lib.indentstring = function(count)
	local result = ""
	for i=1,count do
		result = result .. "  "
	end
	return result
end

lib.indentedlua = function(p, indent)
	if p == nil then
		return "nil"
	end
	if(type(p) == "string") then
		return "\"" .. p .. "\""
	end
	if(type(p) == "table") then
		if indent == nil then indent = 0 end
		local result = "{\n"
		for key, value in pairs(p) do
			result = result .. lib.indentstring(indent + 2) .. key .. " = " .. lib.indentedlua(value, indent + 2) .. ",\n"
		end
		result = result .. lib.indentstring(indent) .. "}" 
		return result
	end
	
	return tostring(p)
end

lib.safetostring = function(p)
	if p == nil then
		return "nil"
	end
	if(type(p) == "string") then
		return "\"" .. p .. "\""
	end
	if(type(p) == "table") then
		local result = "{"
		for key, value in pairs(p) do
			result = result .. key .. ": " .. lib.safetostring(value) .. ", "
		end
		result = result .. " }" 
		return result
	end
	
	return tostring(p)
end

lib.registerUpdateFn = function(modifier, updateFn)
    addModifier(modifier, function(fn, data)
        local oldUpdateFn = data.updateFn
        if data.updateFn ~= nil then
            data.updateFn = function(params)
                local result = oldUpdateFn(params)
                updateFn(params, data, result)                
                return result
            end
        end
        return data
    end)
end

return lib