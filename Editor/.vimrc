" Основные настройки
set number            " Нумерация строк
set relativenumber    " Относительная нумерация строк
set tabstop=4         " Размер табуляции
set shiftwidth=4      " Автоотступы
set expandtab         " Использовать пробелы вместо табуляции
set clipboard=unnamedplus " Включить буфер обмена
syntax on             " Подсветка синтаксиса
filetype plugin indent on " Умная индентация

" Поиск
set ignorecase        " Игнорировать регистр при поиске
set smartcase         " Учитывать регистр, если есть заглавные буквы

" Интерфейс
set cursorline        " Подсветка текущей строки
set hlsearch          " Подсветка найденного
set incsearch         " Пошаговый поиск
set scrolloff=5       " Оставлять 5 строк при прокрутке

" Улучшение копирования
vnoremap <C-c> "+y    " Копирование в системный буфер обмена
nnoremap <C-v> "+p    " Вставка из системного буфера обмена

