if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""" Create a _machine_specific.vim file to adjust machine specific stuff, like python interpreter location.
let has_machine_specific_file = 1
if empty(glob('~/.config/nvim/_machine_specific.vim'))
	let has_machine_specific_file = 0
	silent! exec "!cp ~/.config/nvim/default_configs/_machine_specific_default.vim ~/.config/nvim/_machine_specific.vim"
endif
source ~/.config/nvim/_machine_specific.vim

""" editor behavior

colorscheme darkblue
set background=light
syntax enable

filetype plugin on

set number
set relativenumber
set cursorline
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set list
set listchars=tab:\|\ ,trail:▫
set scrolloff=5
set ttimeoutlen=0
set notimeout
set viewoptions=cursor,folds,slash,unix
set wrap
set tw=0
set indentexpr=
set foldmethod=indent
set foldlevel=99
set foldenable
set formatoptions-=tc
set splitright
set splitbelow
set noshowmode
set showcmd
set wildmenu
set ignorecase
set smartcase
set shortmess+=c
set inccommand=split
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast " should make scrolling faster
set lazyredraw " same as above
set visualbell " ?
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
set colorcolumn=100
set updatetime=100
set virtualedit=block

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""" terminal behaviors
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert
tnoremap <C-N> <C-\><C-N>
tnoremap <C-O> <C-\><C-N><C-O>
let g:terminal_color_0	= '#000000'
let g:terminal_color_1	= '#FF5555'
let g:terminal_color_2	= '#50FA7B'
let g:terminal_color_3	= '#F1FA8C'
let g:terminal_color_4	= '#BD93F9'
let g:terminal_color_5	= '#FF79C6'
let g:terminal_color_6	= '#8BE9FD'
let g:terminal_color_7	= '#BFBFBF'
let g:terminal_color_8	= '#4D4D4D'
let g:terminal_color_9	= '#FF6E67'
let g:terminal_color_10	= '#5AF78E'
let g:terminal_color_11	= '#F4F99D'
let g:terminal_color_12	= '#CAA9FA'
let g:terminal_color_13	= '#FF92D0'
let g:terminal_color_14	= '#9AEDFE'



""" basic operations

let mapleader=" "

noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>

map Q :q<CR>
map S :w<CR>
map R :source $MYVIMRC<CR>

noremap n j
noremap e k
noremap i l

noremap N 5j
noremap E 5k
noremap H 7h
noremap I 7l

noremap <c-h> 0
noremap <c-i> $

noremap k i
noremap K I

""" yank to system clipboard in visual mode
vmap Y "+y

""" select all
noremap <LEADER>sa ggVG

""" search

noremap <LEADER><CR> :nohlsearch<CR>
noremap = nzz
noremap - Nzz

noremap <LEADER>f :FZF ~<CR>


""" split

noremap s <nop>

noremap se :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sn :set splitbelow<CR>:split<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap si :set splitright<CR>:vsplit<CR>

noremap <LEADER>h <c-w>h
noremap <LEADER>n <c-w>j
noremap <LEADER>e <c-w>k
noremap <LEADER>i <c-w>l

""" tab contral

noremap tn :tabe<CR>
noremap th :-tabnext<CR>
noremap ti :+tabnext<CR>

noremap tmh :-tabmove<CR>
noremap tml :+tabmove<CR>

" Compile function
noremap <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc

""" ===== Plugins =====

call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'

Plug 'junegunn/fzf', {'do': { -> fzf#install()}}

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

""" ===== Plugin Settings =====

""" coc.nvim

" TextEdit might fail if hidden is not set.
set hidden

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-o> to trigger completion.
inoremap <silent><expr> <c-o> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `<leader>=` and `<leader>-` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>- <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>= <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <leader>H to show documentation in preview window.
nnoremap <silent> <leader>H :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@





let g:coc_global_extensions = [
	\ 'coc-json',
	\ 'coc-explorer',
	\ 'coc-vimlsp',
	\ 'coc-java',
	\ 'coc-clangd',
	\ 'coc-python']

nmap tt :CocCommand explorer<CR>

""" ===== End of Plugin Settings =====

if has_machine_specific_file == 0
	exec "e ~/.config/nvim/_machine_specific.vim"
endif
