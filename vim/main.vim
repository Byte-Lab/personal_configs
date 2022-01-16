" My main vim configuration file.
"
" Contains mostly default options that I want for all configs, and some code
" that I copied from https://vim.wikia.com/wiki/Example_vimrc.

" Map leader key to space.
nnoremap <SPACE> <Nop>
let mapleader=" "

" Helper function for sourcing a local vim directory.
function! SourceLocal(relativePath)
  let root = "$HOME/.personal_configs/vim"
  let fullPath = root . '/'. a:relativePath
  exec 'source ' . fullPath
endfunction

" Enable plugins.
" NOTE: This must come first. Enabling plugins may override some settings,
" 	such as syntax being enabled.
call SourceLocal("plugins.vim")

" Default options:
call SourceLocal("defaults.vim")

" Custom keybindings:
call SourceLocal("keybindings.vim")

" Configuring plugins:
call SourceLocal("gutentags.vim")
call SourceLocal("ctrlp.vim")
call SourceLocal("airline.vim")
