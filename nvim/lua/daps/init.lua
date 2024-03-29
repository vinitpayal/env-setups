--- steps required for dap to work for json5 based vscode launch.json
-- brew install rustup-init
-- add below in .cargo/config.toml
-- [target.x86_64-apple-darwin]
--rustflags = [
--    "-C", "link-arg=-undefined",
--    "-C", "link-arg=dynamic_lookup",
--]
--
--[target.aarch64-apple-darwin]
--rustflags = [
--    "-C", "link-arg=-undefined",
--    "-C", "link-arg=dynamic_lookup",
--]


vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

local dap = require('dap')
require("dapui").setup()

dap.set_log_level('INFO')

local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

--require('dap.ext.vscode').load_launchjs('../vscode/launch.json', {})

--dap.configurations.python = {
--  {
--    type = 'python',
--    request = 'launch',
--    name = "Launch file",
--    program = "${file}",
--    pythonPath = function()
--      return '/usr/bin/python'
--    end,
--  },
--}
--

local js_based_languages = { "typescript", "javascript", "typescriptreact", "node" }

require("dap-vscode-js").setup({
    adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

--require('dap.ext.vscode').json_decode = require'json5'.parse

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome with \"localhost\"",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    }
  }
end

require('dap.ext.vscode').load_launchjs()
  --{ ['pwa-node'] = js_based_languages,
  --  ['node'] = js_based_languages,
  --  ['chrome'] = js_based_languages,
  --  ['pwa-chrome'] = js_based_languages }
--)
