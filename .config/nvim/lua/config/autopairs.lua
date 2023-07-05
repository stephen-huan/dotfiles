local npairs = require "nvim-autopairs"
local Rule = require "nvim-autopairs.rule"

local latex = { "tex", "latex" }
-- stylua: ignore start
local rules = {
    Rule("\\(", "  \\)", latex)
        :set_end_pair_length(3),
    Rule("\\[", "  \\]", latex)
        :set_end_pair_length(3),
    Rule("$", "  $", "markdown")
        :set_end_pair_length(2),
}
-- stylua: ignore end

for _, rule in pairs(rules) do
    npairs.add_rule(rule)
end
