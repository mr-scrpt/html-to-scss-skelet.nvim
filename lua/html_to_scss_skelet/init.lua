-- html_to_scss_skelet.lua

local M = {}

function M.html_to_scss()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	local html = table.concat(lines, "\n")

	local class_list = {}

	local base_class_set = {}

	for class_str in html:gmatch('class%s*=%s*"([^"]+)"') do
		for cls in class_str:gmatch("%S+") do
			table.insert(class_list, cls)
		end
	end

	local function parse_class(cls)
		-- Ищем первое вхождение '_' или '__'
		local base_class, rest = cls:match("^([^_]+)(_.*)$")
		if not base_class then
			base_class = cls
			rest = ""
		end

		local element = nil
		local modifier = nil

		if rest:sub(1, 2) == "__" then
			element = rest:sub(3)
		elseif rest:sub(1, 1) == "_" then
			modifier = rest:sub(2)
		end

		return base_class, element, modifier
	end

	local structured_classes = {}

	for _, cls in ipairs(class_list) do
		local base_class, element, modifier = parse_class(cls)

		if not base_class_set[base_class] then
			base_class_set[base_class] = true
			table.insert(structured_classes, { base_class = base_class, elements = {}, modifiers = {} })
		end

		local base_entry = nil
		for _, entry in ipairs(structured_classes) do
			if entry.base_class == base_class then
				base_entry = entry
				break
			end
		end

		if element then
			-- Проверяем, добавлен ли уже элемент
			local exists = false
			for _, el in ipairs(base_entry.elements) do
				if el == element then
					exists = true
					break
				end
			end
			if not exists then
				table.insert(base_entry.elements, element)
			end
		elseif modifier then
			-- Проверяем, добавлен ли уже модификатор
			local exists = false
			for _, mod in ipairs(base_entry.modifiers) do
				if mod == modifier then
					exists = true
					break
				end
			end
			if not exists then
				table.insert(base_entry.modifiers, modifier)
			end
		end
	end

	local function build_scss(structured_classes)
		local scss = ""
		for _, entry in ipairs(structured_classes) do
			local base_class = entry.base_class
			local elements = entry.elements
			local modifiers = entry.modifiers

			scss = scss .. "." .. base_class .. " {\n"

			for _, mod in ipairs(modifiers) do
				scss = scss .. "  &_" .. mod .. " {\n  }\n"
			end

			for _, el in ipairs(elements) do
				scss = scss .. "  &__" .. el .. " {\n  }\n"
			end

			scss = scss .. "}\n\n"
		end
		return scss
	end

	local scss_output = build_scss(structured_classes)

	vim.fn.setreg("+", scss_output)
	print("SCSS has been copied to the clipboard.")
end

return M
