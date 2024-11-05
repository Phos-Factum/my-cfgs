-- ~/.config/tvim/init.lua

-- Установка основных параметров
vim.opt.number = true -- Включить номера строк
vim.opt.wrap = true -- Включить перенос строк
vim.opt.linebreak = true -- Перенос строк по словам
vim.opt.textwidth = 100 -- Перенос по 90 символам
vim.opt.spell = true -- Включить проверку орфографии
vim.opt.spelllang = { "en", "ru" } -- Языки для проверки орфографии
vim.opt.background = "light" -- Светлый фон

-- Установка цветовой схемы
vim.cmd("colorscheme Spink") -- или замени на другую цветовую схему, например desert, evening, etc.

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
vim.opt.shiftwidth = 4 -- Начальный отступ для новых абзацев
vim.opt.expandtab = true -- Преобразовать табуляцию в пробелы
vim.opt.autoindent = false -- Отключить авто-отступ при переносе строки
vim.opt.smartindent = false -- Отключить "умный" отступ
vim.opt.breakindent = false -- Отключить сохранение отступа при переносе
vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o", "a" } + { "t" } -- Автоперенос при вводе текста, без авто-отступа

-- Настройка Packer для установки плагинов
require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- Сам Packer
	use("plasticboy/vim-markdown") -- Поддержка Markdown
	use("godlygeek/tabular") -- Форматирование и списки
	use("ishchow/nvim-deardiary") -- Плагин для ведения дневника
	use("flazz/vim-colorschemes") -- Набор различных цветовых схем
end)

-- Привязка Ctrl+C для копирования выделенного текста в системный буфер обмена
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Привязка Ctrl+Shift+C для копирования выделенного текста в системный буфер обмена
vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })
