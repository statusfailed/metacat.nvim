# metacat.nvim

Render diagrams from a
[metacat](https://github.com/statusfailed/metacat)
file from `nvim`.
Assumes [metacat-cli](https://crates.io/crates/metacat-cli) is installed.

To configure using [Lazy.nvim](https://github.com/folke/lazy.nvim), add this to `plugins.lua`:

    {
      "statusfailed/metacat.nvim",
      opts = {
        viewer = { "svgtail" },
      },
    },

Then bind the `render` method to a key (e.g. F6 below) by adding the following to `init.lua`:

    vim.keymap.set("n", "<F6>", require("metacat").render, { desc = "Metacat: render def-arrow as SVG" })

# Configuration

The configuration above uses [svgtail](https://crates.io/crates/svgtail) to
render SVGs.
You can use other programs by setting the `viewer` opt, e.g. for `feh`:

    viewer = { "feh", "--reload", "1" }

`viewer` should be a command which:

- Launches with the path to an SVG as its final argument
- Will auto-reload the file when the file path changes

# See also

- [metacat](https://github.com/statusfailed/metacat)
- [svgtail](https://github.com/statusfailed/svgtail)
- [nvim-hexpr](https://github.com/statusfailed/nvim-hexpr)
