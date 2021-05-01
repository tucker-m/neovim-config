syntax enable
" set background=dark

set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set nu
set norelativenumber
set ignorecase
set smartindent
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=no

set colorcolumn=80
" highlight ColorColumn ctermbg=darkgrey guibg=darkgrey
call plug#begin('~/.vim/plugged')
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'git@github.com:kien/ctrlp.vim.git'
Plug 'git@github.com:sjl/gundo.vim.git'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug '907th/vim-auto-save'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'git@github.com:easymotion/vim-easymotion'
Plug 'chriskempson/base16-vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
call plug#end()

" let base16colorspace=256
source ~/.vimrc_background

let g:auto_save = 1

let g:gundo_prefer_python3 = 1
" let g:gundo_preview_bottom = 1

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

lua require('lspconfig').tsserver.setup{ on_attach=require('completion').on_attach }
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1
lua << EOF
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
if not lspconfig.sample then
  configs.sample = {
    default_config = {
      cmd = {'node', '/Users/tmcknight/repos/vscode-extension-samples/lsp-sample/server/out/server.js', '--node-ipc'};
      filetypes = {'markdown', 'text'};
      root_dir = lspconfig.util.root_pattern('.git');
      settings = {};
    };
  }
end
lspconfig.sample.setup{
  filetypes = { 'text', 'markdown' };
  cmd = {'node', '/Users/tmcknight/repos/vscode-extension-samples/lsp-sample/server/out/server.js', '--stdio'};
  on_attach = require('completion').on_attach;
  root_dir = lspconfig.util.root_pattern('.git');
}

lspconfig.solargraph.setup{
  on_attach = require('completion').on_attach;
}

vim.lsp.set_log_level("error")
EOF
  
set hidden

if executable('rg')
  let g:rg_derive_root='true'
endif

" let g:LanguageClient_serverCommands = {
"       \ 'markdown': ['tcp://127.0.0.1:8084'],
"       \ }
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-staging']
let mapleader = " "

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <leader>wk :wincmd k<CR>
nnoremap <leader>wj :wincmd j<CR>
nnoremap <leader>wh :wincmd h<CR>
nnoremap <leader>wl :wincmd l<CR>
map <Leader> <Plug>(easymotion-prefix)
" nmap <silent> gd <Plug>(lcn-definition)
" nmap <silent> gc <Plug>(lcn-menu)
" nnoremap z :call LanguageClient_contextMenu()<CR>

lua << EOF
require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

require('telescope').load_extension('fzy_native')
EOF

