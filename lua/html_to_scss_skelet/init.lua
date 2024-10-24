-- html_to_scss_skelet.lua

local M = {}

function M.html_to_scss()
	-- Получаем позиции начала и конца выделения
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Извлекаем выделенные линии
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	-- Соединяем линии в один текст
	local html = table.concat(lines, "\n")

	-- Таблица для хранения всех классов
	local class_set = {}

	-- Извлекаем классы из HTML
	for class_str in html:gmatch('class%s*=%s*"([^"]+)"') do
		for cls in class_str:gmatch("%S+") do
			class_set[cls] = true
		end
	end

	-- Функция для разделения класса на базовый класс, элементы и модификаторы
	local function parse_class(cls)
		-- Ищем первое вхождение '_' или '__'
		local base_class, rest = cls:match("^([^_]+)(_.*)$")
		if not base_class then
			-- Если нет подчеркиваний, весь класс считается базовым
			base_class = cls
			rest = ""
		end

		local elements = {}
		local modifiers = {}

		if rest:sub(1, 2) == "__" then
			-- Если rest начинается с '__', это элемент
			table.insert(elements, rest:sub(3))
		elseif rest:sub(1, 1) == "_" then
			-- Если rest начинается с '_', это модификатор
			table.insert(modifiers, rest:sub(2))
		end

		return base_class, elements, modifiers
	end

	-- Таблица для хранения структурированных классов
	local structured_classes = {}

	for cls in pairs(class_set) do
		local base_class, elements, modifiers = parse_class(cls)
		if not structured_classes[base_class] then
			structured_classes[base_class] = { elements = {}, modifiers = {} }
		end

		for _, el in ipairs(elements) do
			structured_classes[base_class].elements[el] = true
		end

		for _, mod in ipairs(modifiers) do
			structured_classes[base_class].modifiers[mod] = true
		end
	end

	-- Функция для создания SCSS скелета
	local function build_scss(structured_classes)
		local scss = ""
		for base_class, data in pairs(structured_classes) do
			scss = scss .. "." .. base_class .. " {\n"

			-- Добавляем модификаторы
			for mod in pairs(data.modifiers) do
				scss = scss .. "  &_" .. mod .. " {\n  }\n"
			end

			-- Добавляем элементы
			for el in pairs(data.elements) do
				scss = scss .. "  &__" .. el .. " {\n  }\n"
			end

			scss = scss .. "}\n"
		end
		return scss
	end

	local scss_output = build_scss(structured_classes)

	-- Копируем результат в буфер обмена
	vim.fn.setreg("+", scss_output)
	print("SCSS скелет скопирован в буфер обмена!")
end

return M
