source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction



"----------------------------------------------------------------
" 编码设置
"----------------------------------------------------------------
"Vim 在与屏幕/键盘交互时使用的编码(取决于实际的终端的设定)        
set encoding=utf-8
set langmenu=zh_CN.UTF-8
" 设置打开文件的编码格式  
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 
set fileencoding=utf-8
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
"set termencoding = cp936  
"设置中文提示
language messages zh_CN.utf-8 
"设置中文帮助
set helplang=cn
"设置为双字宽显示，否则无法完整显示如:☆
set ambiwidth=double
set guifont=Consolas\ for\ Powerline\ FixedD:h15


"----------------------------------------------------------------
" Vundle 插件管理器 
"----------------------------------------------------------------
set rtp+=$VIM/vimfiles/bundle/vundle/  
call vundle#rc('$VIM/vimfiles/bundle/')  
Bundle 'gmarik/vundle'


"--------------------------------------------------------------------------
" Ctags工具是用来遍历源代码文件生成tags文件，
" 这些tags文件能被编辑器或其它工具用来快速查找定位源代码中的符号（tag/symbol），
" 如变量名，函数名等。比如，tags文件就是Taglist和OmniCppComplete工作的基础 
"--------------------------------------------------------------------------


"----------------------------------------------------------------
" taglist是一个用于显示定位程序中各种符号的插件，
" 例如宏定义、变量名、结构名、函数名这些东西 
"----------------------------------------------------------------


"----------------------------------------------------------------
" OmniCppComplete
"----------------------------------------------------------------


"--------------------------------------------------------------------------
" vim-airline 状态栏增强插件，可以让你的Vim状态栏非常的美观，
" 同时包括了buffer显示条扩展smart tab line以及集成了一些插件
"--------------------------------------------------------------------------
Plugin 'vim-airline/vim-airline'
let g:airline_theme="molokai" 
"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   
"打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"设置切换Buffer快捷键"
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>
" 关闭状态显示空白符号计数
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'


"--------------------------------------------------------------------------
" tagbar是一个taglist的替代品，比taglist更适合c++使用 
"--------------------------------------------------------------------------
Plugin 'majutsushi/tagbar' 
" 快捷键设置 
"nmap <Leader>tb :TagbarToggle<CR> 
" ctags程序的路径 
let g:tagbar_ctags_bin='ctags'
"窗口宽度的设置 
let g:tagbar_width=30 
map <F3> :Tagbar<CR> 
"如果是c语言的程序的话，tagbar自动开启
"autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()  


"--------------------------------------------------------------------------
" NERDTree 文件树形资源管理 
"--------------------------------------------------------------------------
Plugin 'scrooloose/nerdtree'
let NERDTreeWinPos='right'
let NERDTreeWinSize=30
map <F2> :NERDTreeToggle<CR>



