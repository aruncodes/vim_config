set number
set autoindent
set shiftwidth=4
set tabstop=4
set smartindent
""set foldmethod=syntax

syntax enable
""colorscheme molokai
"let g:molokai_original=1
"let g:rehash256 = 1

if has("gui_running")
   colorscheme molokai 
else
	colorscheme molokai
	"colorscheme koehler
endif

"if has('mouse')
"	set mouse=a
"endif

" Set backspace"
set backspace=indent,eol,start

" Number toggle

function! NumberToggle()
  if(&relativenumber == 1)
    set number
	set norelativenumber
  else
	  if(&number == 1)
		  set nonumber
      else
          set relativenumber
      endif
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

"Auto close backets "
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j0f}a"
 endif
endf

function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf

" Tab new and close
""nnoremap <C-t>     :tabnew<CR>
""nnoremap <C-k>     :tabclose<CR>
" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>

noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

"Swap lines"
nnoremap <C-S-Up>	ddkP
nnoremap <C-S-Down>	ddp
nnoremap <C-S-D>	yyp

" Pathogen"
execute pathogen#infect()

" Change register to sys clipboard"
set clipboard^=unnamed
set runtimepath^=~/.vim/bundle/ctrlp.vim

if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" add any database in parent directory
	elseif filereadable("../cscope.out")
		cs add ../cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb

	nmap <C-\>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


endif


" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

""highlight OverLength ctermbg=red ctermfg=white guibg=#592929
""match OverLength /\%81v.\+/

if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set cursorline
