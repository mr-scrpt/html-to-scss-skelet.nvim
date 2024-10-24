-- local M = {}

-- -- Функция для извлечения имен классов из строки
-- local function extract_class_names(line)
-- 	local class_names = {}
-- 	-- Поиск class="..."
-- 	for class_attr in string.gmatch(line, 'class%s*=%s*"([^"]+)"') do
-- 		-- Разделение имен классов по пробелам
-- 		for class_name in string.gmatch(class_attr, "%S+") do
-- 			table.insert(class_names, class_name)
-- 		end
-- 	end
-- 	-- Поиск class='...'
-- 	for class_attr in string.gmatch(line, "class%s*=%s*'([^']+)'") do
-- 		for class_name in string.gmatch(class_attr, "%S+") do
-- 			table.insert(class_names, class_name)
-- 		end
-- 	end
-- 	return class_names
-- end
--
-- -- Основная функция для генерации SCSS-скелета
-- function M.generate_scss_skeleton()
-- 	-- Получение выделенного текста
-- 	local s_start = vim.fn.getpos("'<")
-- 	local s_end = vim.fn.getpos("'>")
-- 	local lines = vim.fn.getline(s_start[2], s_end[2])
--
-- 	-- Если выделена одна строка, корректируем колонки
-- 	if #lines == 1 then
-- 		local start_col = s_start[3]
-- 		local end_col = s_end[3]
-- 		lines[1] = string.sub(lines[1], start_col, end_col)
-- 	end
--
-- 	-- Сбор имен классов
-- 	local class_set = {}
-- 	for _, line in ipairs(lines) do
-- 		local class_names = extract_class_names(line)
-- 		for _, class_name in ipairs(class_names) do
-- 			class_set[class_name] = true
-- 		end
-- 	end
--
-- 	-- Определение базового класса
-- 	local base_classes = {}
-- 	for class_name, _ in pairs(class_set) do
-- 		if not string.find(class_name, "__") then
-- 			table.insert(base_classes, class_name)
-- 		end
-- 	end
--
-- 	local base_class = nil
-- 	if #base_classes == 1 then
-- 		base_class = base_classes[1]
-- 	else
-- 		-- Если несколько базовых классов, выбираем первый из HTML
-- 		for _, line in ipairs(lines) do
-- 			local class_names = extract_class_names(line)
-- 			for _, class_name in ipairs(class_names) do
-- 				if not string.find(class_name, "__") then
-- 					base_class = class_name
-- 					break
-- 				end
-- 			end
-- 			if base_class then
-- 				break
-- 			end
-- 		end
-- 	end
--
-- 	if not base_class then
-- 		-- Если базовый класс не найден, берем первый класс
-- 		for class_name, _ in pairs(class_set) do
-- 			base_class = class_name
-- 			break
-- 		end
-- 	end
--
-- 	-- Генерация SCSS-скелета
-- 	local scss_lines = {}
-- 	table.insert(scss_lines, "." .. base_class .. " {")
--
-- 	-- Сбор элементов (классы с '__')
-- 	local elements = {}
--
-- 	for class_name, _ in pairs(class_set) do
-- 		if class_name ~= base_class then
-- 			local prefix = base_class .. "__"
-- 			if string.sub(class_name, 1, #prefix) == prefix then
-- 				local element = string.sub(class_name, #prefix + 1)
-- 				table.insert(elements, element)
-- 			end
-- 		end
-- 	end
--
-- 	-- Добавление элементов
-- 	for _, element in ipairs(elements) do
-- 		table.insert(scss_lines, "  &" .. "__" .. element .. " {")
-- 		table.insert(scss_lines, "  }")
-- 		table.insert(scss_lines, "")
-- 	end
--
-- 	-- Закрытие базового класса
-- 	table.insert(scss_lines, "}")
--
-- 	-- Объединение строк SCSS
-- 	local scss_text = table.concat(scss_lines, "\n")
--
-- 	-- Копирование в буфер обмена
-- 	vim.fn.setreg("+", scss_text)
--
-- 	-- Вывод сообщения
-- 	print("SCSS has been generated and copied to clipboard.")
-- end

-- ============== >>>>>>>>>>>>>>>>>>>>>>>>>
-- ============== >>>>>>>>>>>>>>>>>>>>>>>>>
--
--
local M = {}

local function extract_class_names(line)
	local class_names = {}
	-- Поиск class="..."
	for class_attr in string.gmatch(line, 'class%s*=%s*"([^"]+)"') do
		-- Разделение имен классов по пробелам
		for class_name in string.gmatch(class_attr, "%S+") do
			table.insert(class_names, class_name)
		end
	end
	-- Поиск class='...'
	for class_attr in string.gmatch(line, "class%s*=%s*'([^']+)'") do
		for class_name in string.gmatch(class_attr, "%S+") do
			table.insert(class_names, class_name)
		end
	end
	return class_names
end

-- Основная функция для генерации SCSS-скелета
function M.generate_scss_skeleton()
	-- Получение выделенного текста
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local lines = vim.fn.getline(s_start[2], s_end[2])

	-- Если выделена одна строка, корректируем колонки
	if #lines == 1 then
		local start_col = s_start[3]
		local end_col = s_end[3]
		lines[1] = string.sub(lines[1], start_col, end_col)
	end

	-- Сбор имен классов
	local class_set = {}
	for _, line in ipairs(lines) do
		local class_names = extract_class_names(line)
		for _, class_name in ipairs(class_names) do
			class_set[class_name] = true
		end
	end

	-- Определение базового класса
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
		-- Если несколько базовых классов, выбираем первый из HTML
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
		-- Если базовый класс не найден, берем первый класс
		for class_name, _ in pairs(class_set) do
			base_class = class_name
			break
		end
	end

	-- Генерация SCSS-скелета
	local scss_lines = {}
	table.insert(scss_lines, "." .. base_class .. " {")

	-- Сбор модификаторов и других классов
	local modifiers = {}
	local other_classes = {}

	for class_name, _ in pairs(class_set) do
		if class_name ~= base_class then
			local prefix = base_class
			if string.sub(class_name, 1, #prefix) == prefix then
				local modifier = string.sub(class_name, #prefix + 1)
				table.insert(modifiers, modifier)
			else
				table.insert(other_classes, class_name)
			end
		end
	end

	-- Добавление модификаторов
	for _, modifier in ipairs(modifiers) do
		table.insert(scss_lines, "  &" .. modifier .. " {")
		table.insert(scss_lines, "  }")
		table.insert(scss_lines, "")
	end

	-- Закрытие базового класса
	table.insert(scss_lines, "}")
	table.insert(scss_lines, "")

	-- Добавление других классов
	for _, class_name in ipairs(other_classes) do
		table.insert(scss_lines, "." .. class_name .. " {")
		table.insert(scss_lines, "}")
		table.insert(scss_lines, "")
	end

	-- Объединение строк SCSS
	local scss_text = table.concat(scss_lines, "\n")

	-- Копирование в буфер обмена
	vim.fn.setreg("+", scss_text)

	-- Вывод сообщения
	print("SCSS скелет скопирован в буфер обмена.")
end

return M
