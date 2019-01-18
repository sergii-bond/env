execute pathogen#infect()
Helptags
:helptags ~/.vim/bundle
"`set nocompatible
syntax on
autocmd BufNewFile,BufRead *.md   set syntax=off
filetype plugin indent on
filetype plugin on


" Ctrl-j/k inserts blank line below/above
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
"nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>

let g:flake8_show_in_file=1  " show
"autocmd BufWritePost *.py call Flake8()
nnoremap <F7> :call Flake8()

"let mapleader='\'
"nmap <Leader>a <Plug>ToggleAutoCloseMappings
set pastetoggle=<F5>
"map <F3> :IPython <CR>
"exe "normal \<F3>"
"
set textwidth=160  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set smartindent
set hlsearch

autocmd FileType hpp setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType h setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType js setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Do not remove indent when inserting #, ^H is entered with CTRL-V CTRL-H.
" :inoremap # X#

" disable smartindent for python code, for the sake of # indentation
au! FileType python setl nosmartindent

set tags=~/work/tags_py,~/work/tags_c
map \nt :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']


" ctrlp settings
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,build*
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$|build$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
let g:ctrlp_extensions = ['tag', 'buffertag']

" nnoremap <F8> :execute 'topleft' ((&columns - &textwidth)*2/3) . 'vsplit _paddding_' | wincmd p
map <F8> :execute 'topleft' ((&columns - &textwidth)*2/3) . 'vsplit _paddding_' | wincmd p

" https://andrew.stwrt.ca/posts/vim-ctags/
" https://andrew.stwrt.ca/posts/project-specific-vimrc/
set exrc
set secure
set number

"" Conque-GDB settings
"let g:ConqueGdb_SrcSplit = 'left'
""let g:ConqueTerm_ReadUnfocused = 1
"" :ConqueGdbBDelete
"let g:ConqueTerm_FastMode = 1
"
"let g:ConqueTerm_CWInsert = 1

" reindent the entire file and come back to the same line
map <F7> mzgg=G`z

" list all buffers and choose one
:nnoremap <C-l> :buffers<CR>:buffer<Space>
" save changes before switching to another buffer
set autowrite

" Commenting blocks of code.
" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim#comment27973419_1676672
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Run make
nnoremap <leader>m :make<Enter>

" CtrlP auto cache clearing.
" https://github.com/kien/ctrlp.vim/issues/305
" ----------------------------------------------------------------------------
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * CtrlPClearCache
      autocmd BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * :call SetupCtrlP()
endif


" projectionist options
nnoremap <C-n> :A<CR>

" status line
set laststatus=2

" alighnment of func arguments with = (or =ap)
set cino+=(0

" GOLANG
" https://github.com/fatih/vim-go-tutorial
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>f  :GoFmt<CR>

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" FSwitch https://vim8.org/scripts/script.php?script_id=2590
" Switch between source and header files in c/c++
" noremap <C-h> :FSHere<CR>
nmap <silent> <Leader>of :FSHere<cr>
nmap <silent> <Leader>ol :FSRight<cr>
nmap <silent> <Leader>oL :FSSplitRight<cr>
nmap <silent> <Leader>oh :FSLeft<cr>
nmap <silent> <Leader>oH :FSSplitLeft<cr>
nmap <silent> <Leader>ok :FSAbove<cr>
nmap <silent> <Leader>oK :FSSplitAbove<cr>
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

if &diff
    colorscheme diffcolorscheme
endif
