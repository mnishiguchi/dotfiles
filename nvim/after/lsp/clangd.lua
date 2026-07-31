local cmd = { "clangd", "--background-index" }
local idf_tools_path = vim.fn.expand(vim.env.IDF_TOOLS_PATH or "~/.espressif")

if vim.uv.fs_stat(idf_tools_path .. "/tools") then
	local query_drivers = {
		idf_tools_path .. "/tools/xtensa-*/**/bin/*",
		idf_tools_path .. "/tools/riscv32-esp-elf/**/bin/*",
	}

	table.insert(cmd, "--query-driver=" .. table.concat(query_drivers, ","))
end

---@type vim.lsp.Config
return {
	cmd = cmd,
}
