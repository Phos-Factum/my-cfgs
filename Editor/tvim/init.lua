-- ~/.config/tvim/init.lua

-- Добавляем путь для поиска файлов Lua
package.path = package.path .. ";~/.config/tvim/lua/?.lua"

-- Подключение конфигурации diary.lua для настройки nvim-deardiary
dofile(vim.fn.expand("~/.config/tvim/lua/diary.lua"))

-- Установка основных параметров
vim.opt.number = true -- Включить номера строк
vim.opt.wrap = true -- Включить перенос строк
vim.opt.linebreak = true -- Перенос строк по словам
vim.opt.textwidth = 90 -- Перенос по 90 символам
-- vim.opt.spell = true -- Включить проверку орфографии
-- vim.opt.spelllang = { "en", "ru" } -- Языки для проверки орфографии

-- Автокоманды для заголовков Markdown
vim.api.nvim_create_augroup("MarkdownHeaders", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.cmd("syntax match Heading1 '^# .*$'")
		vim.cmd("highlight Heading1 guifg=Yellow")
		vim.cmd("syntax match Heading2 '^## .*$'")
		vim.cmd("highlight Heading2 guifg=LightGreen")
		vim.cmd("syntax match Heading3 '^### .*$'")
		vim.cmd("highlight Heading3 guifg=Cyan")
	end,
	group = "MarkdownHeaders",
})

-- Форматирование текста
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = false
vim.opt.smartindent = false
vim.opt.breakindent = false
vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o", "a" } + { "t" }

-- Настройка Packer для установки плагинов
require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("plasticboy/vim-markdown")
	use("godlygeek/tabular")
	use("ishchow/nvim-deardiary")
	use("flazz/vim-colorschemes")
end)

-- Привязка Ctrl+C для копирования выделенного текста в системный буфер обмена
vim.opt.clipboard = "unnamedplus" -- Использовать системный буфер обмена для копирования и вставки
vim.keymap.set("v", "<C-s-c>", '"+y', { noremap = true, silent = true })
-- vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Установка цветовой схемы
vim.cmd("colorscheme Spink")

-- Создаем автокоманду для режима DearDiary
vim.api.nvim_create_augroup("DiarySettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "deardiary",
	callback = function()
		-- Отключаем отступы и автоперенос
		vim.opt_local.autoindent = false
		vim.opt_local.smartindent = false
		vim.opt_local.breakindent = false
		vim.opt_local.formatoptions = vim.opt_local.formatoptions - { "c", "r", "o" } + { "t" }

		-- Восстанавливаем цветовую схему
		vim.cmd("colorscheme Spink")
	end,
	group = "DiarySettings",
})

---- Алиасы для удобного пользования дневником

local function open_journal(command)
	-- Запускаем команду для выбора журнала
	vim.cmd("DearDiarySelectJournal")

	-- Выполняем нужную команду для открытия записи (Today, Tomorrow, или Yesterday)
	vim.cmd(command)
end

-- Команда для открытия записи на сегодня
vim.api.nvim_create_user_command("TToday", function()
	open_journal("DearDiaryToday")
end, {})

-- Команда для открытия записи на завтра
vim.api.nvim_create_user_command("TTomorrow", function()
	open_journal("DearDiaryTomorrow")
end, {})

-- Команда для открытия записи за вчера
vim.api.nvim_create_user_command("TYesterday", function()
	open_journal("DearDiaryYesterday")
end, {})
