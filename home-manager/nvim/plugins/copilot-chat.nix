{ pkgs, ...}: {
  programs.nixvim = {
    userCommands = {
      CopilotChatVisual = {
        command.__raw = ''
          function(args)
            local chat = require("CopilotChat")
            local select = require("CopilotChat.select")
            chat.ask(args.args, { selection = select.visual })
          end
        '';
        nargs = "*";
        range = true;
      };
      CopilotChatInline = {
        command.__raw = ''
          function(args)
            local chat = require("CopilotChat")
            local select = require("CopilotChat.select")
            chat.ask(args.args, {
              selection = select.visual,
              window = {
                layout = "float",
                relative = "cursor",
                width = 1,
                height = 0.4,
                row = 1,
              },
            })
          end
        '';
        nargs = "*";
        range = true;
      };
      CopilotChatBuffer = {
        command.__raw = ''
          function(args)
            local chat = require("CopilotChat")
            local select = require("CopilotChat.select")
            chat.ask(args.args, { selection = select.buffer })
          end
        '';
        nargs = "*";
        range = true;
      };
    };

    keymaps = [
      {
        key = "<leader>cch";
        action.__raw = ''
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          end
        '';
        options.desc = "CopilotChat - Help actions";
      }
      {
        key = "<leader>ccp";
        action.__raw = ''
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end
        '';
        options.desc = "CopilotChat - Prompt actions";
      }
      {
        key = "<leader>cce";
        action = "<cmd>CopilotChatExplain<cr>";
        options.desc = "CopilotChat - Explain code";
      }
      {
        key = "<leader>cct";
        action = "<cmd>CopilotChatTests<cr>";
        options.desc = "CopilotChat - Generate tests";
      }
      {
        key = "<leader>ccr";
        action = "<cmd>CopilotChatReview<cr>";
        options.desc = "CopilotChat - Review code";
      }
      {
        key = "<leader>ccR";
        action = "<cmd>CopilotChatRefactor<cr>";
        options.desc = "CopilotChat - Refactor code";
      }
      {
        key = "<leader>ccn";
        action = "<cmd>CopilotChatBetterNamings<cr>";
        options.desc = "CopilotChat - Better Naming";
      }
      {
        key = "<leader>ccv";
        action = ":CopilotChatVisual";
        mode = "x";
        options.desc = "CopilotChat - Open in vertical split";
      }
      {
        key = "<leader>ccx";
        action = ":CopilotChatInline<cr>";
        mode = "x";
        options.desc = "CopilotChat - Inline Chat";
      }
      {
        key = "<leader>cci";
        action.__raw = ''
          function()
            local input = vim.fn.input("Ask Copilot: ")
            if input ~= "" then
              vim.cmd("CopilotChat " .. input)
            end
          end
        '';
        options.desc = "CopilotChat - Ask input";
      }
      {
        key = "<leader>ccm";
        action = "<cmd>CopilotChatCommit<cr>";
        options.desc = "CopilotChat - Generate commit message for all changes";
      }
      {
        key = "<leader>ccM";
        action = "<cmd>CopilotChatCommit<cr>";
        options.desc = "CopilotChat - Generate commit message for all staged changes";
      }
      {
        key = "<leader>ccq";
        action.__raw = ''
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              vim.cmd("CopilotChatBuffer " .. input)
            end
          end
        '';
        options.desc = "CopilotChat - Quick chat";
      }
      {
        key = "<leader>ccd";
        action = "<cmd>CopilotChatDebugInfo<cr>";
        options.desc = "CopilotChat - Debug Info";
      }
      {
        key = "<leader>ccf";
        action = "<cmd>CopilotChatFixDiagnostic<cr>";
        options.desc = "CopilotChat - Fix Diagnostic";
      }
      {
        key = "<leader>ccl";
        action = "<cmd>CopilotChatReset<cr>";
        options.desc = "CopilotChat - Clear buffer and chat history";
      }
      {
        key = "<leader>ccv";
        action = "<cmd>CopilotChatToggle<cr>";
        options.desc = "CopilotChat - Toggle Vsplit";
      }
    ];

    plugins.copilot-chat = {
      enable = true;

      settings = {
        debug = true;
        window = {
          layout = "float";
        };
        auto_follow_cursor = false;
      };
    };
  };
}
