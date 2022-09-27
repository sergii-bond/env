set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'nvie/vim-flake8'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'jpalardy/vim-slime', { 'for': ['python', 'julia']}
Plugin 'hanschen/vim-ipython-cell', { 'for': ['python', 'julia'] }
call vundle#end()
call maktaba#plugin#Detect()
call glaive#Install()
Glaive codefmt plugin[mappings]
Glaive codefmt clang_format_style=Google
" use `:set ft?` to check the detected file type
filetype plugin indent on
syntax on
autocmd BufNewFile,BufRead *.md   set syntax=off

"------------------------------------------
" slime and ipython-cell
"------------------------------------------
" always use tmux
let g:slime_target = 'tmux'
" fix paste issues in ipython
let g:slime_python_ipython = 1
" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

augroup vim_ipython_cell
    au!
    au FileType python nnoremap <buffer><Leader>s :SlimeSend1 ipython --matplotlib<CR> 
    au FileType python,julia nnoremap <buffer><Leader>r :IPythonCellRun<CR>
    au FileType python nnoremap <buffer><Leader>R :IPythonCellRunTime<CR>
    au FileType julia nnoremap <buffer><Leader>c :IPythonCellExecuteCell<CR>
    au FileType julia nnoremap <buffer><Leader>C :IPythonCellExecuteCellJump<CR>
    au FileType python nnoremap <buffer><Leader>c :IPythonCellExecuteCellVerbose<CR>
    au FileType python nnoremap <buffer><Leader>C :IPythonCellExecuteCellVerboseJump<CR>
    " close all Mathontplotlib figure windows
    au FileType python nnoremap <buffer><Leader>x :IPythonCellClose<CR>
    au FileType python nnoremap <buffer><Leader>l :IPythonCellClear<CR>
    au FileType python nnoremap <buffer><Leader>Q :IPythonCellRestart<CR>

    au FileType julia let g:ipython_cell_run_command = 'include("{filepath}")'
    au FileType julia let g:ipython_cell_cell_command = 'include_string(Main, clipboard())'
augroup END


" " map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
" nmap <F9> :IPythonCellInsertAbove<CR>a
" nmap <F10> :IPythonCellInsertBelow<CR>a
"
" " also make <F9> and <F10> work in insert mode
" imap <F9> <C-o>:IPythonCellInsertAbove<CR>
" imap <F10> <C-o>:IPythonCellInsertBelow<CR>

"------------------------------------------
" Ctrlp
"------------------------------------------
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,build*
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$|build$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
let g:ctrlp_extensions = ['tag', 'buffertag']

" CtrlP auto cache clearing.
" https://github.com/kien/ctrlp.vim/issues/305
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      au!
      au FocusGained  * CtrlPClearCache
      au BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * :call SetupCtrlP()
endif

"------------------------------------------
" Flake8
"------------------------------------------
let g:flake8_show_in_file=1  " show
augroup flake8
    au!
    au FileType python nnoremap <buffer> <F7> :call Flake8()
    "au BufWritePost *.python call Flake8()
augroup END

"------------------------------------------
" GOLANG
" https://github.com/fatih/vim-go-tutorial
"------------------------------------------
augroup golang
    au!
    au FileType go nmap <leader>b  <Plug>(go-build)
    au FileType go nmap <leader>r  <Plug>(go-run)
    au FileType go nmap <leader>t  <Plug>(go-test)
    au FileType go nmap <leader>f  :GoFmt<CR>
augroup END
let g:go_version_warning = 0


"------------------------------------------
" FSwitch
"     switch between source and header files in c/c++
"------------------------------------------
augroup fswitch
    au!
    "au FileType hpp,h,cpp,c noremap <buffer> <C-h> :FSHere<CR>
    au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>of :FSHere<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>ol :FSRight<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>oL :FSSplitRight<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>oh :FSLeft<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>oH :FSSplitLeft<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>ok :FSAbove<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>oK :FSSplitAbove<cr>
    "au FileType hpp,h,cpp,c nmap <buffer><silent> <Leader>oJ :FSSplitBelow<cr>
augroup END

"------------------------------------------
" Commenting blocks of code.
" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim#comment27973419_1676672
"------------------------------------------
augroup block_comments
    au!
    autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
    autocmd FileType sh,ruby,python   let b:comment_leader = '# '
    autocmd FileType conf,fstab       let b:comment_leader = '# '
    autocmd FileType tex              let b:comment_leader = '% '
    autocmd FileType mail             let b:comment_leader = '> '
    autocmd FileType vim              let b:comment_leader = '" '
    noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
augroup END

"------------------------------------------
" Other (non-plugin) configuration 
"------------------------------------------
" Ctrl-j/k inserts blank line below/above
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
"nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>

"let mapleader='\'
"nmap <Leader>a <Plug>ToggleAutoCloseMappings
set pastetoggle=<F5>
"map <F3> :IPython <CR>
"exe "normal \<F3>"

set textwidth=160  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
" set autoindent    " align the new line indent with the previous line
" set smartindent
set hlsearch

hi Comment ctermfg=Cyan

"augroup autoformat_settings
"	"autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
"	" autocmd FileType python AutoFormatBuffer autopep8
"	" autocmd FileType python AutoFormatBuffer yapf
"	autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
"augroup END

augroup spacings
    au FileType python setlocal
        \ shiftwidth=4 tabstop=4 softtabstop=4
        \ autoindent nosmartindent

    au FileType hpp,h,cpp,c setlocal 
        \ shiftwidth=2 tabstop=2 softtabstop=2
        \ cindent cino=(0,N-s

    au FileType html,js setlocal
                \ shiftwidth=2 tabstop=2 softtabstop=2

    au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

augroup END

" Do not remove indent when inserting #, ^H is entered with CTRL-V CTRL-H.
" :inoremap # X#

" set tags=~/work/tags_py,~/work/tags_c
"map \nt :NERDTreeToggle<CR>
"let NERDTreeIgnore = ['\.pyc$']



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


" Run make
nnoremap <leader>m :make<Enter>


" status line
set laststatus=2

" alighnment of func arguments with = (or =ap)
set cino+=(0



if &diff
    colorscheme diffcolorscheme
endif

