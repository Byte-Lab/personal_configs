" Custom key bindings.

" Tabs vs. spaces:
map <leader>tab :set tabstop=4<CR>:set noexpandtab<CR>
map <leader>space :set shiftwidth=4<CR>:set softtabstop=4<CR>:set expandtab<CR>

" Paste mode vs. nopaste:
map <leader>paste :set paste<CR>
map <leader>nopaste :set nopaste<CR>

" Remove highlighting:
map <leader>nohl :nohl<CR>

" number vs. nonumber:
map <leader>nonum :set nonumber<CR>
map <leader>num :set number<CR>

" Set a more narrow width for upstream linux emails.
nmap <leader>lkw :set textwidth=75<CR>

" For when you're hacking the linux kernel itself.
nmap <leader>lkst :set noexpandtab tabstop=8 shiftwidth=8<CR>
