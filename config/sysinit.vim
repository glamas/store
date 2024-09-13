" ============================================================================
"               << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" ============================================================================
"               < 判断操作系统是否是 Windows 还是 Linux >
let g:isWindows = 0
let g:isLinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:isWindows = 1
else
    let g:isLinux = 1
endif

" todo：判断 win32unix

"               < 判断是终端还是 Gvim >
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif


" ============================================================================
"               << 软件默认配置 >>
" ============================================================================
"               < Windows Gvim 默认配置>
if (g:isWindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif


"               < Linux Gvim/Vim 默认配置>
if g:isLinux
    if g:isGUI
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " Source a global configuration file if available
        if has("nvim")
            if filereadable("/usr/local/share/nvim/syntax/syntax.vim")
                source /usr/local/share/nvim/syntax/syntax.vim
            endif
        else
            if filereadable("/etc/vim/vimrc")
                source /etc/vim/vimrc
            elseif filereadable("/etc/vimrc")
                source /etc/vimrc
            endif
        endif
    endif
endif


" ============================================================================
"               << 用户自定义配置 >>
" ============================================================================
"               < 文件和编码配置 >
" 禁用 Vi 兼容模式
set nocompatible

" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                              " 设置gvim内部编码
set fileencoding=utf-8                          " 设置当前文件编码
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,gb2312,gb18030,gbk,cp936,latin1       " 设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                             " 设置新文件的<EOL>格式
set fileformats=unix,dos,mac                    " 给出文件的<EOL>格式类型

" 文件类型
filetype on                                     " 启用文件类型侦测
filetype plugin on                              " 针对不同的文件类型加载对应的插件

" windows gui乱码
if (g:isWindows && g:isGUI)
    language messages zh_CN.utf-8               " 解决consle输出乱码
    source $VIMRUNTIME/delmenu.vim              " 解决菜单乱码
    source $VIMRUNTIME/menu.vim
endif

"               < 文件编辑的配置 >
" 代码高亮
if has("syntax")
    syntax on
endif

" 搜索高亮
set hlsearch                                    " 高亮搜索
set incsearch                                   " 在输入要搜索的文字时，实时匹配
set ignorecase                                  " 搜索模式里忽略大小写
set smartcase                                   " 如果搜索模式包含大写字符，不使用 'ignorecase' 选项

" 折叠
set foldenable                                  " 启用折叠
set foldlevel=99                                " 默认不折叠
set foldmethod=manual                           " indent 折叠方式
"set foldmethod=marker                          " marker 折叠方式

" 默认缩进设置
filetype plugin indent on                       " 启用缩进
set smartindent                                 " 启用智能对齐方式
set expandtab                                   " 将Tab键转换为空格
set tabstop=4                                   " 设置Tab键的宽度
set shiftwidth=4                                " 换行时自动缩进4个空格
set smarttab                                    " 指定按一次backspace就删除shiftwidth宽度的空格
set backspace=2                                 " 设置退格键可用，和 :set backspace=indent,eol,start相同

" 根据文件类型设置缩进
autocmd Filetype make setlocal noexpandtab
autocmd Filetype html,htmldjango,css setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 expandtab cc=120
autocmd Filetype c,cpp setlocal ts=4 sw=4 expandtab cc=80,120
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab

" 文件更新和目录切换
set autoread                                    " 当文件在外部被修改，自动更新该文件
autocmd CursorHold,CursorHoldI * checktime
" autocmd BufRead,BufNewFile,BufEnter * cd %:p:h  " 自动切换目录为当前编辑文件所在目录
set autochdir

" 打开文件自动定位到上次的位置
"autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"               < 界面配置 >
set shortmess=atI                               " 去掉欢迎界面
set number                                      " 显示行号
set laststatus=2                                " 启用状态栏信息
set cmdheight=2                                 " 设置命令行的高度为2，默认为1
set showcmd                                     " 显示命令
set cursorline                                  " 突出显示当前行

if has('termguicolors')
    set termguicolors
endif
if g:isGUI
    " 设置 gVim 窗口初始位置及大小
    " autocmd GUIEnter * simalt ~x                   " 窗口启动时自动最大化
    winpos 100 10                               " 指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=42 columns=132                    " 指定窗口大小，lines为高度，columns为宽度

    " 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    map <silent> <c-F11> :
    \if &guioptions =~# 'm' <Bar>
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

    " 设置字体:字号（字体名称空格用下划线代替）
    "set guifont=YaHei_Consolas_Hybrid:h10
    "set guifont=Consolas:h12
    "set guifontwide=Consolas:h12
endif

"               < 其它配置 >
"set nowrap                                     " 设置不自动换行
"set listchars=tab:>-,trail:~
set listchars=tab:∙\ ,trail:º,precedes:«,extends:»
set list
"set complete=.,k,w,b,t
set completeopt=menu,menuone,noselect,longest   " 内置补全设置
"set writebackup                                 " 保存文件前建立备份，保存成功后删除该备份
set nobackup                                    " 设置无备份文件
set nowritebackup
set noswapfile                                  " 设置无临时文件
set t_Co=256                                    " 在终端启用256色
set mouse=a                                     " 在任何模式下启用鼠标
set vb t_vb=                                    " 关闭提示音
"set noimcmdline                                 " 输入法自动切换中文
" 和系统剪切板交互
if has("clipboard")
    set clipboard+=unnamed
endif

" 配置python 虚拟环境 目录名称venv
let venv_list = ["$HOME/.local/venv/", "$HOME/Envs/venv/"]
for venv in venv_list
    if executable(expand(venv . "bin/python"))
        let g:python3_host_prog = expand(venv . "bin/python")
        break
    else
        if executable(expand(venv . "Scripts/python"))
            let g:python3_host_prog = expand(venv . "Scripts/python")
            break
        endif
    endif
endfor
" 避免和已激活虚拟环境冲突，设置$VIRTUAL_ENV为空
let $VIRTUAL_ENV = ""
" python 设置匹配符号展开时的缩进
let python_indent = {
\   'open_paren': 'shiftwidth()',
\   'nested_paren': 'shiftwidth()',
\   'closed_paren_align_last_line': v:false
\}

" ============================================================================
"               << 插件配置 >>
" ============================================================================
"               < 插件安装目录 >
" | OS        | editor | vim_config_path | vim_config_file         | vim_plugin_install_path |
" +-----------+--------+-----------------+-------------------------+-------------------------+
" | linux/bsd | vim    | ~/.vim          | ~/.vimrc                | ~/.vim/packages         |
" |           | nvim   | ~/.config/nvim  | ~/.config/nvim/init.vim | ~/.config/nvim/packages |
" | windows   | vim    | $VIMRUNTIME     | $VIMRUNTIME/_vimrc      | $VIMRUNTIME/packages    |
" |           | nvim   | $VIM            | $VIM/sysinit.vim        | $VIM/packages           |
if g:isLinux
    if has("nvim")
        " 需要手动链接vim的配置
        "ln -s ~/.vim .config/nvim
        "ln -s ~/.vimrc .config/nvim/init.vim
        let g:vim_config_path = "~/.config/nvim"
        let g:vim_plugin_path="~/.config/nvim/autoload/plug.vim"
        let g:vim_plugin_install_path="~/.config/nvim/packages"
    else
        let g:vim_config_path = "~/.vim"
        let g:vim_plugin_path="~/.vim/autoload/plug.vim"
        let g:vim_plugin_install_path="~/.vim/packages"
        if !expand("~/.vim/packages")
            call mkdir(expand("~/.vim"), "p")
        endif
    endif

    let vimplug_exists=expand(g:vim_plugin_path)
    set rtp+=g:vim_plugin_install_path
else
    if has("nvim")
        " 重置Windows环境下neovim的shell，vim的默认shell已经是cmd
        set shell=cmd.exe
        " 需要复制配置文件到/share/nvim/sysinit.vim
        let g:vim_config_path=$VIM
        let g:vim_plugin_path=$VIM . "/autoload/plug.vim"
        let g:vim_plugin_install_path=$VIM . "/packages"
        if !expand(g:vim_plugin_install_path)
            call mkdir(g:vim_plugin_install_path, "p")
        endif
    else
        let g:vim_config_path=$VIMRUNTIME
        let g:vim_plugin_path=$VIMRUNTIME . "/autoload/plug.vim"
        let g:vim_plugin_install_path=$VIMRUNTIME . "/packages"
        if !expand(g:vim_plugin_install_path)
            call mkdir(expand(g:vim_plugin_install_path), "p")
        endif
    endif
    let vimplug_exists=expand(g:vim_plugin_path)
    exec 'set rtp+=' . expand(g:vim_plugin_install_path)
    exec 'set rtp+=' . expand(g:vim_config_path)
endif

" 启动时自动安装插件：http://vim-bootstrap.com/，需要curl和git
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://ghproxy.com/https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  autocmd VimEnter * PlugInstall
endif

" ----------------------------------------------------------------------------
"               < 安装插件 >
" ----------------------------------------------------------------------------
call plug#begin(expand(g:vim_plugin_install_path))
"               < 界面增强 >
Plug 'mhinz/vim-startify'                       " 开始页面
Plug 'itchyny/lightline.vim'                    " 状态栏
Plug 'airblade/vim-gitgutter'                   " 代码状态
Plug 'fholgado/minibufexpl.vim'                 " buffer插件
Plug 'lambdalisue/fern.vim', {'branch': 'main'}         " 目录树
Plug 'yuki-yano/fern-preview.vim'               " 目录树，文件预览
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }      " 撤销目录树，手动 :UndotreeToggle
Plug 'voldikss/vim-floaterm'                    " 终端
Plug 'Yggdroot/LeaderF'                         " 模糊搜索，需要安装ctags和ripgrep，需要+python或者+python3(nvim可以pip install pynvim支持)

"               < 显示增强 >
Plug 'sainnhe/sonokai'                         " 配色方案 https://github.com/sainnhe/sonokai/blob/master/doc/sonokai.txt
"Plug 'NLKNguyen/papercolor-theme'
Plug 'luochen1990/rainbow'                      " 彩虹括号增强版，手动 :RainbowToggle
Plug 'ntpeters/vim-better-whitespace'           " 行尾空格高亮

"               < 编辑增强 >
Plug 'jiangmiao/auto-pairs'                     " 括号自动补全
Plug 'junegunn/vim-easy-align'                  " 对齐插件
"Plug 'mg979/vim-visual-multi'                  " 多光标编辑
Plug 'machakann/vim-sandwich'                   " 匹配符号增强插件
Plug 'dhruvasagar/vim-table-mode'               " 表格增强
Plug 'tomtom/tcomment_vim'                      " 注释插件 https://github.com/tomtom/tcomment_vim  快捷键 gcc

"               < 补全方案/LSP >
Plug 'ludovicchabant/vim-gutentags'             " 项目标签生成 需要ctags
Plug 'ervandew/supertab'                        " tab补全,使用内置方法
"Plug 'lifepillar/vim-mucomplete'
if has("nvim")
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    "Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
    "Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
else
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

call plug#end()

" ----------------------------------------------------------------------------
"               < 插件配置 >
" ----------------------------------------------------------------------------
if exists('g:plugs["vim-startify"]')
    let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
    let g:startify_custom_header = []
    nmap <F4> :Startify<CR>
endif

if exists('g:plugs["rainbow"]')
    let g:rainbow_active = 1
endif

if exists('g:plugs["lightline.vim"]')
function! StatusLineFileSize()
    let l:bytes = line2byte('$') + len(getline('$'))
    let l:sizes = ['B', 'K', 'M', 'G', 'T', 'P']
    let l:i = 0
    while l:bytes >= 1024
        let l:bytes = l:bytes / 1024.0
        let l:i += 1
    endwhile
    return printf('%.1f%s', l:bytes, l:sizes[l:i])
endfunction
    let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'right': [ [ 'lineinfo', 'charvaluehex' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'tabinfo' ],
      \              [ 'filesize' ]
      \            ]
      \ },
      \ 'component': {
      \   'lineinfo': '%3p%%/%L',
      \   'charvaluehex': '%l:%c[0x%04B]',
      \   'tabinfo': '%{(&expandtab)?"space":"tab"}:%{&ts}'
      \ },
      \ 'component_function': {
      \   'filesize': 'StatusLineFileSize'
      \ },
      \ }
endif

if exists('g:plugs["vim-gitgutter"]')
" :GitGutterToggle
" 快捷键：
" ]c            " 下一处变动块
" [c            " 上一处变动块
" <Leader>hp    " 显示变动块
" <Leader>hs    " stage 变动块
" <Leader>hu    " 撤销变动块
"function! GitStatus()
"  let [a,m,r] = GitGutterGetHunkSummary()
"  return printf('+%d ~%d -%d', a, m, r)
"endfunction
"set statusline+=%{GitStatus()}
endif

if exists('g:plugs["vim-sandwich"]')
" 文档 https://github.com/machakann/vim-sandwich
" 命令格式：
"   sa{motion/textobject}{addition}         " 添加
"   sdb / sd{deletion}                      " 删除
"   srb{addition} / sr{deletion}{addition}  " 替换
" motion - ib,is:只包括文字，ab,as:包括边界
" sdb和srb默认是空格，最好明确deletion
endif

if exists('g:plugs["supertab"]')
    let g:SuperTabDefaultCompletionType = "context"   " 从上到下顺序
    let g:SuperTabContextDefaultCompletionType = "<c-n>"
    "let g:SuperTabLongestEnhanced=1
    let g:SuperTabLongestHighlight=1
endif

if exists('g:plugs["vim-table-mode"]')
    " https://github.com/dhruvasagar/vim-table-mode
    " let g:table_mode_corner_corner='+'
    " let g:table_mode_header_fillchar='-'
    let g:table_mode_corner='|'
endif

if exists('g:plugs["coc.nvim"]')
    "let g:coc_node_path = '/path/to/node'
    if (g:isWindows && !g:isGUI && $MSYSTEM!="")
        let g:coc_data_home = $HOME."/.config/coc"
        let g:coc_config_home = $HOME.'/.vim'
    endif
    set hidden
    set shortmess+=c
    set updatetime=300
    if has("nvim-0.5.0") || has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction
    autocmd CursorHold * silent call CocActionAsync('highlight')
endif

if exists('g:plugs["vim-easy-align"]')
    " 参考链接 https://github.com/junegunn/vim-easy-align
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
endif

if exists('g:plugs["vim-better-whitespace"]')
    let g:better_whitespace_enabled=1               " 高亮行尾空格
    let g:strip_whitespace_on_save=0                " 保存时去除行尾空格，置0不去除
    let g:strip_whitelines_at_eof=1                 " 去除文件末尾空格
    let g:show_spaces_that_precede_tabs=1           " 高亮tab前和tab内部的空格
    let g:better_whitespace_skip_empty_lines=0      " 置1忽略纯空格的行
    "let g:strip_whitespace_confirm=1                " 删除前确认
    " 默认下列文件格式对该插件屏蔽，若不注释则所有格式都开启
    let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown']
    " 在行尾空格快速移动
    nnoremap ]w :NextTrailingWhitespace<CR>
    nnoremap [w :PrevTrailingWhitespace<CR>
    " <number><Leader>s<space>                      " 清除N行行尾空格
    " <Leader>s<motion>                             " 根据<motion>清除，如<Leader>sip清除当前段落行尾空格
endif

if exists('g:plugs["undotree"]')
    " 显示样式，（tree，diff）：1左上，左下，2左上，底部，3右上，右下，4右上，底部
    let g:undotree_WindowLayout = 3
    if has("persistent_undo")
        let undodir_path=expand(g:vim_config_path."/undodir/")
        exec "set undodir=" . undodir_path
        if !expand(undodir_path)
            call mkdir(undodir_path, "p")
        endif
        set undofile
    endif
    nnoremap <F3> :UndotreeToggle<CR>
endif

if exists('g:plugs["vim-floaterm"]')
    let g:floaterm_keymap_new    = '<Leader>tc'
    let g:floaterm_keymap_kill   = '<Leader>tk'
    let g:floaterm_keymap_prev   = '<Leader>tp'
    let g:floaterm_keymap_next   = '<Leader>tn'
    let g:floaterm_keymap_toggle = '<F12>'

    if &shell != ""
        let g:floaterm_shell=&shell
    elseif executable("bash")
        let g:floaterm_shell='bash'
    elseif executable("sh")
        let g:floaterm_shell='sh'
    endif
    let g:floaterm_autoclose=1
endif

if exists('g:plugs["fern.vim"]')
    " https://github.com/lambdalisue/fern.vim/wiki/FAQ
    " https://github.com/lambdalisue/fern.vim/wiki/Mappings
    " 常用操作：
    " fi - 筛选包含，ctrl+u清空已输入
    " fe - 筛选排除
    " a - 选择并操作
    " ! - 显示隐藏文件
    " . - 重复操作
    " ? - 帮助
    nmap <F2> :Fern . -drawer -reveal=% -toggle<CR>
endif

if exists('g:plugs["fern-preview.vim"]')
    function! s:fern_settings() abort
      nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
      nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
      nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
      nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
    endfunction

    augroup fern-settings
      autocmd!
      autocmd FileType fern call s:fern_settings()
    augroup END
endif

if exists('g:plugs["LeaderF"]')
    " ripgrep: https://github.com/BurntSushi/ripgrep/releases
    " ctags: https://github.com/universal-ctags/ctags-win32/releases

    let g:Lf_ShowDevIcons = 0
    let g:Lf_PreviewInPopup = 1
    let g:Lf_PreviewPopupWidth = &columns * 3 / 4
    let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
    let g:Lf_WorkingDirectoryMode = 'Ac'

    noremap <leader>ff :<C-U><C-R>=printf("Leaderf file %s", "")<CR><CR>
    noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
    noremap <leader>fm :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
    noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
    noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
    noremap <leader>fg :<C-U><C-R>=printf("Leaderf rg -F -e %s", "")<CR>
endif

" 设置插件主题
set background=dark
if exists('g:plugs["sonokai"]')
    let g:sonokai_style = 'shusia'
    let g:sonokai_enable_italic = 0
    let g:sonokai_disable_italic_comment = 1
    let g:sonokai_better_performance = 1
    colorscheme sonokai
else
    colorscheme default
endif

if has("nvim") && exists('g:plugs["mason.nvim"]')
lua <<endoflua
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
        function (server_name)
            require("lspconfig")[server_name].setup {}
        end
    }
endoflua

endif

" ----------------------------------------------------------------------------
"               - 自定义快捷键，避免插件覆盖 -
" ----------------------------------------------------------------------------
" 设置<Leader>键
let mapleader = "\\"

" 终端模式下，Esc退出命令
tnoremap <Esc> <C-\><C-n>

" 使用z+[.-<CR>]方式跳转，上下保留一行
nnoremap z<CR> z<CR><c-y>                       " 当前行移动到顶部
nnoremap z- z-<c-e>                             " 当前行移动到底部

" 常规模式下，空格翻页。如果配置了其他<space>开头的键映射，这里翻页会停顿一下
nmap <space> <c-f>

" 用空格键来开关折叠
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 行尾空格处理，常规模式下输入 cS 清除行尾空格，输入 cM 清除行尾 ^M 符号
nmap cS :%s/\s\+$//g<CR>:noh<CR>
nmap cM :%s/\r$//g<CR>:noh<CR>

" 插入模式下光标移动
"inoremap <a-k> <Up>
"inoremap <a-j> <Down>
"inoremap <a-h> <Left>
"inoremap <a-l> <Right>

" 搜索跳转，将光标位置置于中间
nnoremap n nzzzv
nnoremap N Nzzzv

"" 清除搜索高亮
nnoremap <silent> <leader><space> :noh<cr>

" 区块选中后，上下移动
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" 大写状态时，保存和退出
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" windows 下ctrl z挂起的问题
if (g:isWindows)
    nmap <c-z> <c-l>
endif

" ============================================================================
"               << windows 下解决 Quickfix 乱码问题 >>
" ============================================================================
" windows 默认编码为 cp936，而 Gvim(Vim) 内部编码为 utf-8，所以常常输出为乱码
" 以下代码可以将编码为 cp936 的输出信息转换为 utf-8 编码，以解决输出乱码问题
" 但好像只对输出信息全部为中文才有满意的效果，如果输出信息是中英混合的，那可能
" 不成功，会造成其中一种语言乱码，输出信息全部为英文的好像不会乱码
" 如果输出信息为乱码的可以试一下下面的代码，如果不行就还是给它注释掉

" if g:isWindows
"     function QfMakeConv()
"         let qflist = getqflist()
"         for i in qflist
"            let i.text = iconv(i.text, "cp936", "utf-8")
"         endfor
"         call setqflist(qflist)
"      endfunction
"      autocmd QuickfixCmdPost make call QfMakeConv()
" endif


" ============================================================================
"               << 自定义函数 >>
" ============================================================================

function GetLocalTime(format)
    let l:time= localtime()
    if a:format == "date"
        let l:format = "%Y-%m-%d"
    elseif a:format == "time"
        let l:format = "%H:%M:%S"
    elseif a:format
        let l:format = a:format
    else
        let l:format = "%Y-%m-%d %H:%M:%S"
    endif
    if exists("*strftime")
            return strftime(l:format,l:time)
    else
            return l:time
    endif
endfunction

