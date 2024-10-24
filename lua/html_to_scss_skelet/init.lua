-- html_to_scss_skelet.lua

local M = {}

function M.html_to_scss()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	local html = table.concat(lines, "\n")

	local classes = {}

	for class in html:gmatch('class%s*=%s*"([^"]+)"') do
		for cls in class:gmatch("[^%s]+") do
			table.insert(classes, cls)
		end
	end

	local hash = {}
	local unique_classes = {}
	for _, v in ipairs(classes) do
		if not hash[v] then
			unique_classes[#unique_classes + 1] = v
			hash[v] = true
		end
	end

	local function build_scss(classes)
		local scss = ""
		local parent_class = nil
		for _, cls in ipairs(classes) do
			if not cls:find("__") and not cls:find("%-%-") then
				parent_class = cls
				scss = scss .. "." .. cls .. " {\n"
			elseif cls:find("__") then
				local element = cls:match("__([%w%d_-]+)")
				scss = scss .. "  &__" .. element .. " {\n  }\n"
			elseif cls:find("%-%-") then
				local modifier = cls:match("%-%-([%w%d_-]+)")
				scss = scss .. "  &--" .. modifier .. " {\n  }\n"
			end
		end
		if parent_class then
			scss = scss .. "}\n"
		end
		return scss
	end

	local scss_output = build_scss(unique_classes)

	vim.fn.setreg("+", scss_output)
	print("SCCSS copied to clipboard!")
end

return M
