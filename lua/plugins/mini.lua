return {
  { 'nvim-mini/mini.nvim', version = false },
  {
    'nvim-mini/mini.files',
    config = function()
      local minifiles = require 'mini.files'
      minifiles.setup {
        -- windows = { preview = true },
        hooks = {
          on_init = function(config)
            local mf = require 'mini.files'
            vim.keymap.set('n', '|', function()
              local path = mf.get_fs_entry().path
              mf.close()
              vim.cmd('vsplit ' .. vim.fn.fnameescape(path))
            end, { buffer = config.buf_id, desc = 'Open in vertical split' })
          end,
        },
      }
      local show_dotfiles = true

      local filter_show = function(fs_entry)
        return true
      end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh { content = { filter = new_filter } }
      end

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)

          -- This intentionally doesn't act on file under cursor in favor of
          -- explicit "go in" action (`l` / `L`). To immediately open file,
          -- add appropriate `MiniFiles.go_in()` call instead of this comment.
          MiniFiles.go_in()
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, '\\', 'belowright vertical')
          map_split(buf_id, '|', 'tab')
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
        end,
      })
      vim.keymap.set('n', '<leader>ee', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Open File Explorer' })
      vim.keymap.set('n', '<leader>ef', function()
        minifiles.open(vim.api.nvim_buf_get_name(0), false)
        minifiles.reveal_cwd()
      end, { desc = 'Open File Explorer at current file' })
    end,
  },
}
