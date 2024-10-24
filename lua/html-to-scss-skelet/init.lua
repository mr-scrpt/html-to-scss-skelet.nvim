local M = {}

local function extract_class_names(line)
	local class_names = {}
	for class_attr in string.gmatch(line, 'class%s*=%s*"([^"]+)"') do
		for class_name in string.gmatch(class_attr, "%S+") do
			table.insert(class_names, class_name)
		end
	end
	for class_attr in string.gmatch(line, "class%s*=%s*'([^']+)'") do
		for class_name in string.gmatch(class_attr, "%S+") do
			table.insert(class_names, class_name)
		end
	end
	return class_names
end

function M.generate_scss_skeleton()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local lines = vim.fn.getline(s_start[2], s_end[2])

	if #lines == 1 then
		local start_col = s_start[3]
		local end_col = s_end[3]
		lines[1] = string.sub(lines[1], start_col, end_col)
	end

	local class_set = {}
	for _, line in ipairs(lines) do
		local class_names = extract_class_names(line)
		for _, class_name in ipairs(class_names) do
			class_set[class_name] = true
		end
	end

	local base_classes = {}
	for class_name, _ in pairs(class_set) do
		if not string.find(class_name, "__") then
			table.insert(base_classes, class_name)
		end
	end

	local base_class = nil
	if #base_classes == 1 then
		base_class = base_classes[1]
	else
		for _, line in ipairs(lines) do
			local class_names = extract_class_names(line)
			for _, class_name in ipairs(class_names) do
				if not string.find(class_name, "__") then
					base_class = class_name
					break
				end
			end
			if base_class then
				break
			end
		end
	end

	if not base_class then
		for class_name, _ in pairs(class_set) do
			base_class = class_name
			break
		end
	end

	local scss_lines = {}
	table.insert(scss_lines, "." .. base_class .. " {")

	local elements = {}

	for class_name, _ in pairs(class_set) do
		if class_name ~= base_class then
			local prefix = base_class .. "__"
			if string.sub(class_name, 1, #prefix) == prefix then
				local element = string.sub(class_name, #prefix + 1)
				table.insert(elements, element)
			end
		end
	end

	for _, element in ipairs(elements) do
		table.insert(scss_lines, "  &" .. "__" .. element .. " {")
		table.insert(scss_lines, "  }")
		table.insert(scss_lines, "")
	end

	table.insert(scss_lines, "}")

	local scss_text = table.concat(scss_lines, "\n")

	vim.fn.setreg("+", scss_text)

	print("SCSS has been generated and copied to clipboard.")
end

return M
