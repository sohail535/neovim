-- ~/.config/nvim/ftplugin/java.lua
function SearchFileBackwards(fn)
	local fp = vim.fn.expand("%:p")
	local pos = #fp
	local pom = ""
	while pos > 0 do
		if fp:sub(pos, pos) == "/" then
			pom = fp:sub(1, pos) .. fn
			if vim.fn.filereadable(pom) == 1 then
				break
			end
		end
		pos = pos - 1
	end
	return pom
end

function BuildMavenProject()
	local pom = SearchFileBackwards("pom.xml")
	if pom ~= "" then
		vim.fn.system("mvn -f " .. pom .. " compile")
		vim.api.nvim_echo({ { "Maven reload complete" } }, true, {})
	else
		vim.api.nvim_echo({ { "No pom.xml found.", "WarningMsg" } }, true, {})
	end
end

-- Press <F8> to build current maven project.
vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":lua BuildMavenProject()<CR>", { silent = true })

-- comment out below line to enable automatic build on maven project.
-- vim.api.nvim_command("autocmd BufWritePost *.java lua BuildMavenProject()")
