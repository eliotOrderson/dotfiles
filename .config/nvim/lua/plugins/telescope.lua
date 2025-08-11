return {
  {
    "telescope.nvim",
    opts = {
      defaults = {
        -- 你也可以选 horizontal、vertical、flex 等布局，根据需要来
        layout_strategy = "horizontal",
        -- layout_config = {
        --   width = 0.9,
        --   height = 0.8,
        --   preview_width = 0.6,
        -- },

        -- layout_strategy = "vertical",
        -- layout_config = {
        -- height = 0.95,  -- 弹窗高度占屏幕的 95%
        -- preview_width = 0.65,  -- 如果需要控制预览窗口的宽度
        -- width = function(_, cols, _)
        --   if cols > 200 then
        --     return 170
        --   else
        --     return math.floor(cols * 0.87)
        --   end
        -- end,
        -- },
      },
    },
  },
}
