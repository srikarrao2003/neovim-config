local status_ok, autosave = pcall(require, "autosave")
if not status_ok then
	return
end

autosave.setup({
	enabled = true,

	execution_message = {
		message = "AutoSaved",
		dim = 0.18,
		clear_in_insert_mode = true,
	},

	trigger_events = { "InsertLeave", "TextChanged" },

	condition = function(buf)
		local fn = vim.fn
		local bufname = fn.bufname(buf)

		-- Skip if not modifiable or special buffers
		if not vim.bo[buf].modifiable or vim.bo[buf].buftype ~= "" then
			return false
		end

		-- Skip excluded filetypes
		local excluded = {
			"oil",
			"alpha",
			"NvimTree",
			"neo-tree",
			"Trouble",
			"lazy",
			"mason",
			"TelescopePrompt",
			"help",
			"gitcommit",
			"dashboard",
		}

		if vim.tbl_contains(excluded, vim.bo[buf].filetype) then
			return false
		end

		-- Skip temp files and git files
		return not bufname:match("/tmp/") and not bufname:match("COMMIT_EDITMSG")
	end,

	write_all_buffers = false,
	debounce_delay = 1000,
})
