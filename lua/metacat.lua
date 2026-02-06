local M = {}

local config = {
  viewer = nil,
}

local state = {
  svg_path = nil,
  viewer_job = nil,
}

function M.setup(opts)
  opts = opts or {}
  config.viewer = opts.viewer
end

local function find_def_arrow()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  for i = row, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    local name = line:match("%(def%-arrow%s+(%S+)")
    if name then
      return name
    end
  end
  return nil
end

function M.render()
  if not config.viewer then
    vim.notify("metacat: 'viewer' not configured", vim.log.levels.ERROR)
    return
  end

  vim.cmd("silent write")

  local name = find_def_arrow()
  if not name then
    vim.notify("metacat: no (def-arrow ...) found above cursor", vim.log.levels.WARN)
    return
  end

  if not state.svg_path then
    state.svg_path = vim.fn.tempname() .. ".svg"
  end

  local bufpath = vim.api.nvim_buf_get_name(0)
  local stdout_chunks = {}
  local stderr_chunks = {}
  vim.fn.jobstart({ "metacat", "arrow", "svg", bufpath, name, "--orientation", "tb" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(stdout_chunks, line)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_chunks, line)
          end
        end
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 and #stderr_chunks > 0 then
          vim.notify("metacat: " .. table.concat(stderr_chunks, "\n"), vim.log.levels.ERROR)
        else
          local f = io.open(state.svg_path, "w")
          if f then
            f:write(table.concat(stdout_chunks, "\n"))
            f:close()
          end

          -- Start the viewer if it's not already running
          if not state.viewer_job and config.viewer then
            local cmd = vim.list_extend({}, config.viewer)
            table.insert(cmd, state.svg_path)
            state.viewer_job = vim.fn.jobstart(cmd, {
              on_exit = function()
                state.viewer_job = nil
              end,
            })
          end
        end
      end)
    end,
  })
end

return M
