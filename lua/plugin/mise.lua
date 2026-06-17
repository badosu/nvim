vim.pack.add({ { src = "https://plugins.ejri.dev/mise.nvim" } })

-- MUST run after mason or anything that changes PATH
require("mise").setup()
