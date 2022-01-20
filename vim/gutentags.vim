" Configure gutentags projects. Much of this is taken from the following page:
" https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
let g:gutentags_add_default_project_roots = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 1
" Set to 0 if you want gutentags to block when opening a file.
let g:gutentags_background_update = 1
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_enabled = 1
set statusline+=%{gutentags#statusline()}

"""""""""""""""""""""""""
" Gutentags keybindings "
"""""""""""""""""""""""""

" Jump up in stack.
nmap <leader>o <c-o>

" Search for all instances of a tag's definition.
nmap <leader>ts g]
nmap <leader>tg g<c-]>
nmap <leader>tgt <C-w><C-]><C-w>T

" Search for a specific instance of a tag's definition.
nmap <leader>fg <c-]>

let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*.o',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
