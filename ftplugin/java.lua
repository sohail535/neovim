-- ~/.config/nvim/ftplugin/java.lua
local home = os.getenv("HOME")

function BuildGradleProject()
	io.popen("./gradlew restart &> /dev/null")
end

vim.api.nvim_command("autocmd BufWritePost *.java lua BuildGradleProject()")

local jdtls = require("jdtls")
local root_markers = { "gradlew", ".git", "mvnw" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local mason_pacakges = home .. "/.local/share/nvim/mason/packages"
local asdf_installs = home .. "/.asdf/installs"
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		asdf_installs .. "/java/adoptopenjdk-17.0.10+7/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. mason_pacakges .. "/jdtls/lombok.jar",
		"-jar",
		mason_pacakges .. "/jdtls/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar",
		"-configuration",
		mason_pacakges .. "/jdtls/config_linux",
		"-data",
		workspace_folder,
	},

	root_dir = root_dir,

	-- If you are developing in projects with different Java versions, you need
	-- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- And search for `interface RuntimeOption`
	-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = asdf_installs .. "/java/adoptopenjdk-8.0.402+6",
					},
					{
						name = "JavaSE-17",
						path = asdf_installs .. "/java/adoptopenjdk-17.0.10+7",
					},
				},
			},
		},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {},
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
