" =============================================================================
" 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim
" =============================================================================


" -----------------------------------------------------------------------------
" 判断操作系统是否是 Windows 还是 Linux
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
" elseif has('gui_macvim')
"     let g:ismac = 1
else
    let g:islinux = 1
endif


" -----------------------------------------------------------------------------
" 判断是终端还是 Gvim
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif




" =============================================================================
" 以下为软件默认配置
" =============================================================================


" -----------------------------------------------------------------------------
" Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
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
endif


" -----------------------------------------------------------------------------
"  Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif

        set background=light 
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        " 在任何模式下启用鼠标，iTerm的鼠标选中自动复制功能会被覆盖
        " set mouse=a                  
        " 在终端启用256色
        set t_Co=256                   
        " 设置退格键可用
        set backspace=2                

        set background=dark

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif




" =============================================================================
" 以下为用户自定义配置
" =============================================================================


" -----------------------------------------------------------------------------
" Vundle 插件管理工具配置
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

" 禁用 Vi 兼容模式
set nocompatible
" 禁用文件类型侦测
filetype off

if g:islinux
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#rc()
else
    set rtp+=$VIM/vimfiles/bundle/Vundle.vim
    call vundle#rc('$VIM/vimfiles/bundle/')
endif

" 使用Vundle来管理插件，这个必须要有。
Plugin 'VundleVim/Vundle.vim'

" 以下为要安装或更新的插件，不同仓库都有（具体书写规范请参考帮助）
"Plugin 'tomasr/molokai'
Plugin 'Valloric/YouCompleteMe'
"Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-scripts/TagHighlight'
Plugin 'kosl90/qt-highlight-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'yggdroot/indentline'
Plugin 'Raimondi/delimitMate'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline'




" -----------------------------------------------------------------------------
" 编码配置
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错

" 设置gvim内部编码，默认不更改
set encoding=utf-8
" 设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencoding=utf-8
" 设置支持打开的文件的编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1

" 文件格式，默认 ffs=dos,unix
" 设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformat=unix
" 给出文件的<EOL>格式类型
set fileformats=unix,dos,mac

if (g:iswindows && g:isGUI)
    " 解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " 解决consle输出乱码
    language messages zh_CN.utf-8

    " 设置中文帮助
    set helplang=cn
    " 设置为双字宽显示，否则无法完整显示如:☆
    set ambiwidth=double

endif




" -----------------------------------------------------------------------------
" 编写文件时的配置
" -----------------------------------------------------------------------------
" 启用文件类型侦测
filetype on
" 针对不同的文件类型加载对应的插件
filetype plugin on
" 启用缩进
filetype plugin indent on
" 启用智能对齐方式
set smartindent
" 将Tab键转换为空格
set expandtab
" 设置Tab键的宽度，可以更改，如：宽度为2
set tabstop=4
" 换行时自动缩进宽度，可更改（宽度同tabstop）
set shiftwidth=4
" 指定按一次backspace就删除shiftwidth宽度
set smarttab
" 启用折叠
set foldenable
" indent 折叠方式
set foldmethod=indent
" 折叠的层次，打开文件时默认不折叠
set foldlevel=9999
" 搜索模式里忽略大小写
"set ignorecase
"set smartcase
" 当文件在外部被修改，自动更新该文件
set autoread
" 使用系统粘贴板,或"+y复制，"+P粘贴
"set clipboard=unnamed
" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>
" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>


" -----------------------------------------------------------------------------
" 备份
" -----------------------------------------------------------------------------
if g:iswindows
    if !isdirectory(expand("~/.vim/backup/"))
        silent !mkdir .\.vim\backup
    endif
    if !isdirectory(expand("~/.vim/swap/"))
        silent !mkdir .\.vim\swap
    endif
    if !isdirectory(expand("~/.vim/undo/"))
        silent !mkdir .\.vim\undo
    endif
else
    if !isdirectory(expand("~/.vim/backup/"))
        silent !mkdir -p ~/.vim/backup
    endif
    if !isdirectory(expand("~/.vim/swap/"))
        silent !mkdir -p ~/.vim/swap
    endif
    if !isdirectory(expand("~/.vim/undo/"))
        silent !mkdir -p ~/.vim/undo
    endif
endif
" 打开backup, undo, swap 
set backup
set undofile
set swapfile
" 交换文件路径
set directory=~/.vim/swap/
" 设置备份文件后缀
set backupext=.bak
" 设置备份路径
set backupdir=~/.vim/backup/
" 备份多版本
au BufWritePre * let &bex = '-' . strftime('%Y%m%d-%H%M%S') . '.vimbackup'
" 设置un~文件路径
set undodir=~/.vim/undo/


" -----------------------------------------------------------------------------
" 界面配置
" -----------------------------------------------------------------------------
" 显示行号
set number
" 启用状态栏信息
set laststatus=2
" 设置命令行的高度为2，默认为1
set cmdheight=1
" 突出显示当前行
"set cursorline
" 设置字体:字号（字体名称空格用下划线代替）
set guifont=Source\ Code\ Pro\ Medium:h15
" 设置不自动换行
set nowrap
" 去掉欢迎界面
set shortmess=atI
"补全菜单的高度，自己定义"
set pumheight=10

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " 窗口启动时自动最大化
    "au GUIEnter * simalt ~x
    " 指定窗口出现的位置，坐标原点在屏幕左上角
    winpos 100 10
    " 指定窗口大小，lines为高度，columns为宽度
    set lines=38 columns=120
endif

" 语法高亮
syntax enable
syntax on

" 设置代码配色方案
if g:isGUI
    " Gvim配色方案
    colorscheme solarized
else
    " 终端配色方案
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    colorscheme solarized
    " colorscheme molokai
    " let g:molokai_original = 1
    " let g:rehash256 = 1
endif

" 显示/隐藏菜单栏、工具栏、滚动条，可用 F12 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <F12> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif




" =============================================================================
" 以下为常用插件配置
" =============================================================================

" -----------------------------------------------------------------------------
" YouCompleteMe 代码补全
" -----------------------------------------------------------------------------
" 配置默认的ycm_extra_conf.py
if g:iswindows
    let g:ycm_global_ycm_extra_conf = $VIM . '/vimfiles/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
else
    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
endif
" 打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_confirm_extra_conf = 1
" 使用ctags生成的tags文件
"let g:ycm_collect_identifiers_from_tag_files = 1
" 引入 C++ 标准库tags
"set tags+=/data/misc/software/misc./vim/stdcpp.tags
" python解析器
if g:iswindows
    let g:ycm_python_binary_path = 'c:/Python27/python'
else
    let g:ycm_python_binary_path = '/usr/local/bin/python3'
endif
" 补全后自动关闭预览窗口
let g:ycm_autoclose_preview_window_after_completion = 1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc = 0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax = 1
" 从第2个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion = 2
" 在注释输入中也能补全
let g:ycm_complete_in_comments = 1
" 在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
" 注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" 补全内容以分割子窗口形式出现
" let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion  = 1
" 直接触发自动补全
let g:ycm_key_invoke_completion = '<C-Space>'
" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'nerdtree' : 1,
            \}
" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
" 离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" 回车即选中当前项
"inoremap <expr> <CR> pumvisible() ? '<C-y>' : '\<CR>'
" 按,jd 会跳转到定义
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" gt可以获得该变量类型
"nnoremap <leader>gt :YcmCompleter GetType<CR>
" gp可以跳转到它的父类的声明处
"nnoremap <leader>gp :YcmCompleter GetParent<CR>
nnoremap <leader>yd :YcmDiags<CR>

" 菜单
" highlight Pmenu ctermfg=2 ctermbg=3 guifg=#005f87 guibg=#EEE8D5
" 选中项
" highlight PmenuSel ctermfg=2 ctermbg=3 guifg=#AFD700 guibg=#106900



" -----------------------------------------------------------------------------
" TagHighlight 类/结构体/枚举等数据类型添加语法高亮显示
" -----------------------------------------------------------------------------
" 保存文件时更新
autocmd BufWrite *.cpp,*.h,*.c :UpdateTypesFile
" map <Leader>th :UpdateTypesFile<CR>


" " -----------------------------------------------------------------------------
" " vim-cpp-enhanced-highlight 语法高亮
" " -----------------------------------------------------------------------------
" let g:cpp_class_scope_highlight = 1
" let g:cpp_member_variable_highlight = 1
" "let g:cpp_class_decl_highlight = 1
" let g:cpp_concepts_highlight = 1
" let g:cpp_experimental_simple_template_highlight = 1
" "let g:cpp_experimental_template_highlight = 1
" "let g:cpp_no_function_highlight = 1


" -----------------------------------------------------------------------------
" NERDTree 文件树形资源管理
" -----------------------------------------------------------------------------
let NERDTreeChDirMode = 1
" 窗口位置
let NERDTreeWinPos = 'left'
" 显示隐藏文件
let NERDTreeShowHidden = 1
" NERDTree 子窗口中不显示冗余帮助信息
" let NERDTreeMinimalUI = 1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer = 1
" 显示书签
let NERDTreeShowBookmarks = 1
" 窗口大小
let NERDTreeWinSize = 30
" 忽略文件类型
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$']
map <Leader>nt :NERDTreeToggle<CR>


" -----------------------------------------------------------------------------
" indentLine 插件配置
" -----------------------------------------------------------------------------

" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
" 开启/关闭对齐线
nmap <leader>il :IndentLinesToggle<CR>

" 设置Gvim的对齐线样式
if g:isGUI
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "┊"
endif

" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239
" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
"let g:indentLine_color_gui = '#A4E57E'
" 设置默认为关闭
let g:indentLine_enabled = 0


" -----------------------------------------------------------------------------
" delimitMate 自动补全单引号，双引号等
" -----------------------------------------------------------------------------
let g:delimitMate_expand_cr = 1


" -----------------------------------------------------------------------------
" ctrlp 快速文件搜索和跳转，支持mru搜索
" -----------------------------------------------------------------------------


" -----------------------------------------------------------------------------
" nerdcommenter 快速注释
" -----------------------------------------------------------------------------
" \cc 注释当前行和选中行  
" \cn 没有发现和\cc有区别  
" \c<空格> 如果被选区域有部分被注释，则对被选区域执行取消注释操作，其它情况执行反转注释操作  
" \cm 对被选区域用一对注释符进行注释，前面的注释对每一行都会添加注释  
" \ci 执行反转注释操作，选中区域注释部分取消注释，非注释部分添加注释  
" \cs 添加性感的注释，代码开头介绍部分通常使用该注释  
" \cy 添加注释，并复制被添加注释的部分  
" \c$ 注释当前光标到改行结尾的内容  
" \cA 跳转到该行结尾添加注释，并进入编辑模式  
" \ca 转换注释的方式，比如： /**/和//  
" \cl \cb 左对齐和左右对其，左右对其主要针对/**/  
" \cu 取消注释  " 在左注释符之后，右注释符之前留有空格
let NERDSpaceDelims = 1


" -----------------------------------------------------------------------------
" tagbar是一个taglist的替代品，比taglist更适合c++使用
" -----------------------------------------------------------------------------
" 快捷键设置
nmap <Leader>tb :TagbarToggle<CR>
" ctags程序的路径
if g:iswindows
    let g:tagbar_ctags_bin = $VIM.'/vim80/ctags'
else
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
endif
" 窗口宽度的设置
let g:tagbar_width = 30
" 在左侧窗口中显示
"let g:tagbar_left=1
"map <F10> :Tagbar<CR>
" 如果是c语言的程序的话，tagbar自动开启
"autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()


" -----------------------------------------------------------------------------
" vim-airline 状态栏增强插件，可以让你的Vim状态栏非常的美观，
" 同时包括了buffer显示条扩展smart tab line以及集成了一些插件
" -----------------------------------------------------------------------------
let g:airline_theme="solarized"
" 这个是安装字体后 必须设置此项"
let g:airline_powerline_fonts = 0
" 打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" 设置切换Buffer快捷键"
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>
" 关闭状态显示空白符号计数
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" old vim-powerline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''
" let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'





" =============================================================================
" 以下为常用工具配置
" =============================================================================


" -----------------------------------------------------------------------------
" Ctags工具是用来遍历源代码文件生成tags文件，
" 这些tags文件能被编辑器或其它工具用来快速查找定位源代码中的符号（tag/symbol），
" 如变量名，函数名等。比如，tags文件就是Taglist和OmniCppComplete工作的基础
" ctrl+], ctrl+t
" -----------------------------------------------------------------------------
set tags=tags;
set autochdir


" -----------------------------------------------------------------------------
" Cscope是类似于ctags一样的工具，但可以认为她是ctags的增强版
" :cs find s function_name 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
" :cs find g function_name 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能 
" :cs find d function_name 查找本函数调用的函数
" :cs find c function_name 查找调用本函数的函数   这个也比较有用处
" :cs find t function_name 查找指定的字符串
" :cs find e function_name 查找egrep模式，相当于egrep功能，但查找速度快多了
" :cs find f function_name 查找并打开文件，类似vim的find功能
" :cs find i function_name 查找包含本文件的文件 
" -----------------------------------------------------------------------------
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
if has("cscope")
    if g:iswindows
        set csprg=$VIM/vim80/cscope
    else
        set csprg=/usr/local/bin/cscope
    endif
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>a :cs find a <C-R>=expand("<cword>")<CR><CR>


" -----------------------------------------------------------------------------
" 更新tags, cscope
" -----------------------------------------------------------------------------
map <F6> :call Do_CsTag()<CR>
function Do_CsTag()
    let dir = getcwd()

    if filereadable("tags")
        if g:iswindows
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if tagsdeleted
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif

    if has("cscope")
        silent! execute "cs kill -1"
    endif
    
    if filereadable("cscope.files")
        if g:iswindows
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if csfilesdeleted
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif

    if filereadable("cscope.out")
        if g:iswindows
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if csoutdeleted
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif

    if executable('ctags')
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif

    if (executable('cscope') && has("cscope"))
        if g:iswindows
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.py > cscope.files"
        else
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.py' > cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
