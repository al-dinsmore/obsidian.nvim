local log = require "obsidian.log"
local util = require "obsidian.util"

---Extract the selected text into a new note
---and replace the selection with a link to the new note.
---
---@param client obsidian.Client
return function(client, data)
  local row, start_col, end_col, link_id, content = util.get_cursor_link()
  if link_id then
    vim.print("link_id: " .. link_id)
  end
  if row and start_col and end_col and content then
    local title = util.strip_whitespace(content)
    --vim.print("title: " .. title)
    --vim.print("row: " .. row)
    --vim.print("start_col: " .. start_col)
    --vim.print("end_col: " .. end_col)
    -- create the new note.
    local note = client:create_note { title = title }

    -- replace selection with link to new note
    local link = client:format_link(note)
    vim.api.nvim_buf_set_text(0, row - 1, start_col - 1, row - 1, end_col + 1, { link })
    client:update_ui(0)

    -- add the selected text to the end of the new note
    client:open_note(note, { sync = true })
    --vim.api.nvim_buf_set_lines(0, -1, -1, false, string[content])
  end
end
