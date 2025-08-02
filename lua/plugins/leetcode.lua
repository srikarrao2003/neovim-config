local status_ok, leetcode = pcall(require, "leetcode")
if not status_ok then
    return
end

leetcode.setup({
      arg = "leetcode.nvim",
      lang = "cpp", -- Change to your preferred language
      cn = { -- leetcode.cn
        enabled = false,
        translator = true,
        translate_problems = true,
      },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },
      plugins = {
        non_standalone = false,
      },
      logging = true,
      injector = {
        ["python3"] = {
          before = true,
        },
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
        ["java"] = {
          before = "import java.util.*;",
        },
      },
      cache = {
        update_interval = 60 * 60 * 24 * 7, -- 7 days
      },
      console = {
        open_on_runcode = true,
        dir = "row",
        size = {
          width = "90%",
          height = "75%",
        },
        result = {
          size = "60%",
        },
        testcase = {
          virt_text = true,
          size = "40%",
        },
      },
      description = {
        position = "left",
        width = "40%",
        show_stats = true,
      },
})

vim.keymap.set("n", "<space>kq", "<cmd>Leet list<cr>", { desc = "LeetCode: List problems" })
vim.keymap.set("n", "<space>kl", "<cmd>Leet<cr>", { desc = "LeetCode: Open menu" })
vim.keymap.set("n", "<space>kr", "<cmd>Leet run<cr>", { desc = "LeetCode: Run code" })
vim.keymap.set("n", "<space>ks", "<cmd>Leet submit<cr>", { desc = "LeetCode: Submit" })
vim.keymap.set("n", "<space>kt", "<cmd>Leet test<cr>", { desc = "LeetCode: Test" })
vim.keymap.set("n", "<space>ko", "<cmd>Leet open<cr>", { desc = "LeetCode: Open problem" })
vim.keymap.set("n", "<space>kc", "<cmd>Leet console<cr>", { desc = "LeetCode: Toggle console" })
vim.keymap.set("n", "<space>ki", "<cmd>Leet info<cr>", { desc = "LeetCode: Problem info" })
vim.keymap.set("n", "<space>kd", "<cmd>Leet desc<cr>", { desc = "LeetCode: Toggle description" })
