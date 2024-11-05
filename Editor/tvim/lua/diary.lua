local config = require("deardiary.config")

config.journals = {
	{
		path = "~/Diary/personal",
		frequencies = { "daily", "weekly" },
	},
	{
		path = "~/Diary/work",
		frequencies = { "daily", "weekly", "monthly", "yearly" },
	},
}
