
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspaces_dir = vim.env.HOME .. '/.cache/jdt_workspaces/'

vim.loop.fs_mkdir(workspaces_dir, 7*8*8 + 5*8 + 5)

local workspace_dir = workspaces_dir .. project_name

local config = {
	cmd = {
		'/home/alan/Downloads/jdtls/bin/jdtls',
		'--data', workspace_dir
	},
	cmd_env = {
		JAVA_HOME = '/usr/lib/jvm/java-17-openjdk'
	},
	settings = {
		java = {
			configuration = {
				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- And search for `interface RuntimeOption`
				-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/usr/lib/jvm/java-8-openjdk/",
					},
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk/",
					},
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk/",
					},
					{
						name = "JavaSE-20",
						path = "/usr/lib/jvm/java-20-openjdk/",
					},
				}
			}
		}
	}
}
require('jdtls').start_or_attach(config)
