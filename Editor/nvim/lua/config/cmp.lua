local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-n>"] = cmp.mapping.complete(), -- Вызов меню вручную через Ctrl + n
  },
  completion = {
    autocomplete = false, -- Полное отключение автозаполнения
  },
})
