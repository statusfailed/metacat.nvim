# metacat.nvim

Render diagrams from a
[metacat](https://github.com/statusfailed/metacat).
file from inside `nvim`.

To configure using [Lazy.nvim](https://github.com/folke/lazy.nvim), add this to `plugins.lua`:

    {
      "statusfailed/metacat.nvim",
      opts = {
        viewer = { "feh", "--reload", "1" },
      },
    },


You can then bind the `render` method to a key, e.g. F6 by adding the following to `init.lua`:

    vim.keymap.set("n", "<F6>", require("metacat").render, { desc = "Metacat: render def-arrow as SVG" })

NOTE: assumes the `metacat` tool is installed.

See also [nvim-hexpr](https://github.com/statusfailed/nvim-hexpr)
