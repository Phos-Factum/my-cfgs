-- ~/.config/tvim/init.lua

-- Добавляем путь для поиска файлов Lua
package.path = package.path .. ";~/.config/tvim/lua/?.lua"

dofile(vim.fn.expand("~/.config/tvim/lua/diary.lua"))

-- Установка основных параметров
vim.opt.number = true -- Включить номера строк
vim.opt.wrap = true -- Включить перенос строк
vim.opt.linebreak = true -- Перенос строк по словам
vim.opt.textwidth = 100 -- Перенос по 100 символам
vim.opt.spell = true -- Включить проверку орфографии
vim.opt.spelllang = { "en", "ru" } -- Языки для проверки орфографии

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
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })

-- Установка цветовой схемы
vim.cmd("colorscheme Spink")
