local M = {}

function M.merge_list(...)
	local result = {}
	local seen = {}

	for _, list in ipairs({ ... }) do
		if list then
			for _, item in ipairs(list) do
				if not seen[item] then
					seen[item] = true
					table.insert(result, item)
				end
			end
		end
	end

	return result
end

function M.merge_maps(...)
	local result = {}

	for _, map in ipairs({ ... }) do
		if map then
			for key, value in pairs(map) do
				result[key] = value
			end
		end
	end

	return result
end

function M.merge_profiles(...)
	local merged = {
		tools = {},
		formatters = {},
		linters = {},
		servers = {},
	}

	for _, profile in ipairs({ ... }) do
		if profile then
			merged.tools = M.merge_list(merged.tools, profile.tools)
			merged.formatters = M.merge_maps(merged.formatters, profile.formatters)
			merged.linters = M.merge_maps(merged.linters, profile.linters)
			merged.servers = M.merge_maps(merged.servers, profile.servers)
		end
	end

	return merged
end

return M
