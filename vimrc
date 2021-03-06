scriptencoding utf-8

"-----------------------------------------------------------------------
" Vim settings file for Danny van Dyk, shamelessly stolen from
" Ciaran McCreesh
"
" I finally added some comments, so you can have some vague idea of
" what all this does.
"
"-----------------------------------------------------------------------

"-----------------------------------------------------------------------
" terminal setup
"-----------------------------------------------------------------------

if &term =~ "xterm"
    if has('title')
        set title
    endif
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif

"-----------------------------------------------------------------------
" settings
"-----------------------------------------------------------------------

" Fix errorformat for gcc-4.5 and higher
set errorformat+=,%-GIn\ file\ included\ from\ %f:%l

" Don't be compatible with vi
set nocompatible

" Enable a nice big viminfo file
set viminfo='1000,f1,:1000,/1000
set history=500

" Make backspace delete lots of things
set backspace=indent,eol,start

" Create backups
set backup

" Show us the command we're typing
set showcmd

" Highlight matching parens
set showmatch

" Search options: incremental search, highlight search
set hlsearch
set incsearch

" Selective case insensitivity
if has("autocmd")
    autocmd BufEnter *
                \ if &filetype == "cpp" |
                \     set noignorecase noinfercase |
                \ else |
                \     set ignorecase infercase |
                \ endif
else
    set ignorecase
    set infercase
endif

" Show full tags when doing search completion
set showfulltag

" Speed up macros
set lazyredraw

" No annoying error noises
set noerrorbells
set visualbell t_vb=
if has("autocmd")
    autocmd GUIEnter * set visualbell t_vb=
endif

" Try to show at least three lines and two columns of context when
" scrolling
set scrolloff=3
set sidescrolloff=2

" Wrap on these
set whichwrap+=<,>,[,]

" Use the cool tab complete menu
set wildmenu
set wildignore+=*.o,*~,.lo
set suffixes+=.in,.a

" Allow edit buffers to be hidden
set hidden

" 1 height windows
set winminheight=1

" Enable syntax highlighting
if has("syntax")
    syntax on
endif

" Set our fonts
if has("gui_kde")
    set guifont=Terminus\ 10
elseif has("gui_gtk")
    set guifont=Terminus\ 10
elseif has("gui_running")
    set guifont=-xos4-terminus-medium-r-normal--12-140-72-72-c-80-iso8859-1
endif

" Try to load a nice colourscheme
if has("eval")
    fun! LoadColourScheme(schemes)
        let l:schemes = a:schemes . ":"
        while l:schemes != ""
            let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
            let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
            try
                exec "colorscheme" l:scheme
                break
            catch
            endtry
        endwhile
    endfun

    if has('gui')
        call LoadColourScheme("inkpot:night:rainbow_night:darkblue:elflord")
    else
        if has("autocmd")
            autocmd VimEnter *
                        \ if &t_Co == 88 || &t_Co == 256 |
                        \     call LoadColourScheme("inkpot:darkblue:elflord") |
                        \ else |
                        \     call LoadColourScheme("darkblue:elflord") |
                        \ endif
        else
            if &t_Co == 88 || &t_Co == 256
                call LoadColourScheme("inkpot:darkblue:elflord")
            else
                call LoadColourScheme("darkblue:elflord")
            endif
        endif
    endif
endif

" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
end

" By default, go for an indent of 4
set shiftwidth=4

" Do clever indent things. Don't make a # force column zero.
set autoindent
set smartindent
inoremap # X<BS>#

" Syntax when printing
set popt+=syntax:y

" Enable filetype settings
if has("eval")
    filetype on
    filetype plugin on
    filetype indent on
endif

" Enable modelines only on secure vim versions
if (v:version >= 604)
    set modeline modelines=10
else
    set nomodeline
endif

" Nice statusbar
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          " vim buddy
endif
set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" special statusbar for special windows
if has("autocmd")
    au FileType qf
                \ if &buftype == "quickfix" |
                \     setlocal statusline=%2*%-3.3n%0* |
                \     setlocal statusline+=\ \[Compiler\ Messages\] |
                \     setlocal statusline+=%=%2*\ %<%P |
                \ endif

    fun! <SID>FixMiniBufExplorerTitle()
        if "-MiniBufExplorer-" == bufname("%")
            setlocal statusline=%2*%-3.3n%0*
            setlocal statusline+=\[Buffers\]
            setlocal statusline+=%=%2*\ %<%P
        endif
    endfun

    au BufWinEnter *
                \ let oldwinnr=winnr() |
                \ windo call <SID>FixMiniBufExplorerTitle() |
                \ exec oldwinnr . " wincmd w"
endif

" Nice window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                     " file name
    set titlestring+=%h%m%r%w                " flags
    set titlestring+=\ -\ %{v:progname}      " program name
endif

" If possible, try to use a narrow number column.
if v:version >= 700
    try
        setlocal numberwidth=3
    catch
    endtry
endif

" Include $HOME in cdpath
if has("file_in_path")
    let &cdpath=','.expand("$HOME").','.expand("$HOME").'/work'
endif

" Better include path
set path+=src/
" set path+=/usr/lib/gcc/*/4.*/include/g++-v4/

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:»·,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif

set fillchars=fold:-

" Filter expected errors from make
if has("eval") && v:version >= 700
    let &makeprg='nice -n3 make $* 2>&1 \| sed -u -n '
    let &makeprg.='-e "/should fail/s/:\([0-9]\)/∶\1/g" '
    let &makeprg.='-e "/usr.share.aclocal.*underquoted/s/:\([0-9]\)/∶\1/g" '
    let &makeprg.='-e "s/\([0-9]\{2\}\):\([0-9]\{2\}\):\([0-9]\{2\}\)/\1∶\2∶\3/g" '
    let &makeprg.='-e "/-version-info/s/:\([0-9]\)/∶\1/g" '
    let &makeprg.='-e "/^/p" '
endif

"-----------------------------------------------------------------------
" completion
"-----------------------------------------------------------------------
set dictionary=/usr/share/dict/words

"-----------------------------------------------------------------------
" autocmds
"-----------------------------------------------------------------------

if has("eval")

    " If we're in a wide window, enable line numbers.
    fun! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=1
            setlocal number
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endfun

    " Force active window to the top of the screen without losing its
    " size.
    fun! <SID>WindowToTop()
        let l:h=winheight(0)
        wincmd K
        execute "resize" l:h
    endfun

    " Update .*rc header
    fun! <SID>UpdateRcHeader()
        let l:c=col(".")
        let l:l=line(".")
        1,10s-\(Most recent update:\).*-\="Most recent update: ".strftime("%c")-e
        call cursor(l:l, l:c)
    endfun

    if v:version >= 700
        " Load gcov marks
        hi UncoveredSign guibg=#2e2e2e guifg=#e07070
        hi CoveredSign guibg=#2e2e2e guifg=#70e070
        sign define uncovered text=## texthl=UncoveredSign
        sign define covered text=## texthl=CoveredSign
        fun! <SID>LoadGcovMarks()
            if ! filereadable(expand("%").".gcov")
                return
            endif
            sign unplace *
            for l:x in map(map(filter(readfile(expand("%").".gcov"),
                        \ '! match(v:val, "^\\s*#\\+:")'),
                        \ 'substitute(v:val,"^[^:]\\+:\\s*\\(\\d\\+\\):.*","\\1","")'),
                        \ '":sign place " . v:val . " line=" . v:val . " name=uncovered " .
                        \ "file=" . expand("%")')
                exec l:x
            endfor
            for l:x in map(map(filter(readfile(expand("%").".gcov"),
                        \ '! match(v:val, "^\\s*\\d\\+:")'),
                        \ 'substitute(v:val,"^[^:]\\+:\\s*\\(\\d\\+\\):.*","\\1","")'),
                        \ '":sign place " . v:val . " line=" . v:val . " name=covered " .
                        \ "file=" . expand("%")')
                exec l:x
            endfor
        endfun

        fun! <SID>UpdateCopyrightHeaders()
            let l:a = 0
            for l:x in getline(1, 10)
                let l:a = l:a + 1
                if -1 != match(l:x, 'Copyright (c) [- 0-9,]*\(200[456789]\|2010\) Danny van Dyk')
                    if input("Update copyright header? (y/N) ") == "y"
                        call setline(l:a, substitute(l:x, '\(200[456789]\|2010\) Danny',
                                    \ '\1, 2011 Danny', ""))
                    endif
                endif
            endfor
        endfun

        noremap <Leader>ch :call <SID>UpdateCopyrightHeaders()<CR>
    endif
endif

" autocmds
if has("autocmd") && has("eval")
    augroup ciaranm
        autocmd!

        " Automagic line numbers
        autocmd BufEnter * :call <SID>WindowWidth()

        " Update header in .vimrc and .bashrc before saving
        autocmd BufWritePre *vimrc  :call <SID>UpdateRcHeader()
        autocmd BufWritePre *bashrc :call <SID>UpdateRcHeader()

        " Always do a full syntax refresh
        autocmd BufEnter * syntax sync fromstart

        " For help files, move them to the top window and make <Return>
        " behave like <C-]> (jump to tag)
        autocmd FileType help :call <SID>WindowToTop()
        autocmd FileType help nmap <buffer> <Return> <C-]>

        " For svn-commit, don't create backups
        autocmd BufRead svn-commit.tmp :setlocal nobackup

        " m4 matchit support
        autocmd FileType m4 :let b:match_words="(:),`:',[:],{:}"

        " Detect procmailrc
        autocmd BufRead procmailrc :setfiletype procmail

        " bash-completion ftdetects
        autocmd BufNewFile,BufRead /*/*bash*completion*/*
                    \ if expand("<amatch>") !~# "ChangeLog" |
                    \     let b:is_bash = 1 | set filetype=sh |
                    \ endif

        " load gcov for c++ files
        autocmd FileType cpp call <SID>LoadGcovMarks()

        " update copyright headers
        autocmd BufWritePre * call <SID>UpdateCopyrightHeaders()

        try
            " if we have a vim which supports QuickFixCmdPost (vim7),
            " give us an error window after running make, grep etc, but
            " only if results are available.
            autocmd QuickFixCmdPost * botright cwindow 5

            autocmd QuickFixCmdPre make
                        \ let g:make_start_time=localtime()

            " Similarly, try to automatically run ./configure and / or
            " autogen if necessary.
            autocmd QuickFixCmdPre make
                        \ if ! filereadable('Makefile') |
                        \     if ! filereadable("configure") |
                        \         exec "! ./autogen.bash" |
                        \     endif |
                        \     if filereadable("configure") |
                        \         if (match(getcwd(), "paludis") >= 0) |
                        \             exec "! ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --enable-qa --enable-gtk --disable-gtktests --enable-ruby --enable-glsa --with-repositories=default,gems,cran --with-clients=default,gtkpaludis,contrarius,inquisitio" |
                        \         elseif (match(getcwd(), "libwrapiter") >= 0) |
                        \             exec "! ./configure --prefix=/usr --sysconfdir=/etc" |
                        \         else |
                        \             exec "! ./configure" |
                        \         endif |
                        \     endif |
                        \ endif

            autocmd QuickFixCmdPost make
                        \ let g:make_total_time=localtime() - g:make_start_time |
                        \ echo printf("Time taken: %dm%2.2ds", g:make_total_time / 60,
                        \     g:make_total_time % 60)

            autocmd QuickFixCmdPre *
                        \ let g:old_titlestring=&titlestring |
                        \ let &titlestring="[ " . expand("<amatch>") . " ] %f %h%m%r%w - %{v:progname}" |
                        \ redraw

            autocmd QuickFixCmdPost *
                        \ let &titlestring=g:old_titlestring
        catch
        endtry

        try
            autocmd Syntax *
                        \ syn match VimModelineLine /^.\{-1,}vim:[^:]\{-1,}:.*/ contains=VimModeline |
                        \ syn match VimModeline contained /vim:[^:]\{-1,}:/
            hi def link VimModelineLine comment
            hi def link VimModeline     special
        catch
        endtry
    augroup END
endif

" content creation
if has("autocmd")
    augroup content
        autocmd!

        autocmd BufNewFile *.rb 0put ='# vim: set sw=4 sts=4 et tw=80 :' |
                    \ 0put ='#!/usr/bin/ruby' | set sw=4 sts=4 et tw=80 |
                    \ norm G

        autocmd BufNewFile *.hh 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | call MakeIncludeGuards() |
                    \ 5put ='#include \"config.h\"' |
                    \ set sw=4 sts=4 et tw=80 | norm G

        autocmd BufNewFile *.cc 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                    \ 1put ='' | 2put ='' | call setline(3, '#include "' .
                    \ substitute(expand("%:t"), ".cc$", ".hh", "") . '"') |
                    \ set sw=4 sts=4 et tw=80 | norm G

        autocmd BufNewFile configure.ac
                    \ 0put ='dnl vim: set sw=8 sts=8 noet :' |
                    \ $put ='' |
                    \ call setline(line('$'), 'AC_INIT([' . substitute(expand('%:p:h'),
                    \     '^.\{-}/\([^/]\+\)\(/trunk\)\?$', '\1', '') . '], [0.0])') |
                    \ $put ='AC_PREREQ(2.5)' |
                    \ $put ='AC_CONFIG_SRCDIR([])' |
                    \ $put ='AC_CONFIG_AUX_DIR(config)' |
                    \ $put ='AM_INIT_AUTOMAKE(1.9)' |
                    \ $put ='' |
                    \ $put ='dnl check for required programs' |
                    \ $put ='AC_PROG_CXX' |
                    \ $put ='AC_PROG_INSTALL' |
                    \ $put ='AC_PROG_LN_S' |
                    \ $put ='AC_PROG_RANLIB' |
                    \ $put ='AC_PROG_MAKE_SET' |
                    \ $put ='' |
                    \ $put ='dnl output' |
                    \ $put ='AM_CONFIG_HEADER(config.h)' |
                    \ $put ='AC_OUTPUT(' |
                    \ $put ='	Makefile' |
                    \ $put ='	src/Makefile' |
                    \ $put ='	)' |
                    \ set sw=8 sts=8 noet |
                    \ norm ggjjjjf]

        autocmd BufNewFile autogen.bash
                    \ 0put ='#!/usr/bin/env bash' |
                    \ 1put ='# vim: set sw=4 sts=4 et tw=80 :' |
                    \ $put ='run() {' |
                    \ $put ='echo \">>> $@\"' |
                    \ $put ='    if ! $@ ; then' |
                    \ $put ='        echo \"oops!\" 1>&2' |
                    \ $put ='        exit 127' |
                    \ $put ='    fi' |
                    \ $put ='}' |
                    \ $put ='' |
                    \ $put ='get() {' |
                    \ $put ='    type ${1}-${2}    &>/dev/null && echo ${1}-${2}    && return' |
                    \ $put ='    type ${1}${2//.}  &>/dev/null && echo ${1}${2//.}  && return' |
                    \ $put ='    type ${1}         &>/dev/null && echo ${1}         && return' |
                    \ $put ='    echo \"Could not find ${1} ${2}\" 1>&2' |
                    \ $put ='    exit 127' |
                    \ $put ='}' |
                    \ $put ='' |
                    \ $put ='run mkdir -p config' |
                    \ $put ='run $(get libtoolize 1.5 ) --copy --force --automake' |
                    \ $put ='rm -f config.cache' |
                    \ $put ='run $(get aclocal 1.9 )' |
                    \ $put ='run $(get autoheader 2.59 )' |
                    \ $put ='run $(get autoconf 2.59 )' |
                    \ $put ='run $(get automake 1.9 ) -a --copy' |
                    \ set sw=4 sts=4 et tw=80 |
                    \ norm gg=Ggg

        autocmd BufNewFile Makefile.am
                    \ 0put ='CLEANFILES = *~' |
                    \ if (! filereadable(expand("%:p:h:h") . '/Makefile.am')) |
                    \     $put ='MAINTAINERCLEANFILES = Makefile.in configure config/* aclocal.m4 \' |
                    \     $put ='' |
                    \     call setline(line('$'), "\t\t\tconfig.h config.h.in") |
                    \     $put ='AUTOMAKE_OPTIONS = foreign dist-bzip2' |
                    \     $put ='EXTRA_DIST = autogen.bash' |
                    \ else |
                    \     $put ='MAINTAINERCLEANFILES = Makefile.in' |
                    \ endif

    augroup END
endif

"-----------------------------------------------------------------------
" mappings
"-----------------------------------------------------------------------

nmap   <silent> <S-Right>  :bnext<CR>

" v_K is really really annoying
vmap K k

" Delete a buffer but keep layout
if has("eval")
    command! Kwbd enew|bw #
    nmap     <C-w>!   :Kwbd<CR>
endif

" quickfix things
nmap <Leader>cwc :cclose<CR>
nmap <Leader>cwo :botright copen 5<CR><C-w>p
nmap <Leader>cn  :cnext<CR>

" Annoying default mappings
inoremap <S-Up>   <C-o>gk
inoremap <S-Down> <C-o>gj
noremap  <S-Up>   gk
noremap  <S-Down> gj

" Make <space> in normal mode go down a page rather than left a
" character
noremap <space> <C-f>

" Useful things from inside imode
inoremap <C-z>w <C-o>:w<CR>
inoremap <C-z>q <C-o>gq}<C-o>k<C-o>$

" Commonly used commands
nmap <silent> <F3> :silent nohlsearch<CR>
imap <silent> <F3> <C-o>:silent nohlsearch<CR>
nmap <F4> :Kwbd<CR>
nmap <F5> <C-w>c
nmap <F7> :make check<CR>
nmap <S-F7> :exec "make -C " . expand("%:p:h") . " check"<CR>
nmap <F8> :make<CR>
nmap <S-F8> :exec "make -C " . expand("%:p:h")<CR>
nmap <F10> :!if [[ -d .svn ]] ; then svn update ; else svk update ; fi<CR>
nmap <F11> :!if [[ -d .svn ]] ; then svn status ; else svk status ; fi \| grep -v '^?' \| sort -k2<CR>

" Insert a single char
noremap <Leader>i i<Space><Esc>r

" Split the line
nmap <Leader>n \i<CR>

" Pull the following line to the cursor position
noremap <Leader>J :s/\%#\(.*\)\n\(.*\)/\2\1<CR>

" In normal mode, jj escapes
inoremap jj <Esc>

" Kill line
noremap <C-k> "_dd

" Select everything
noremap <Leader>gg ggVG

" Reformat everything
noremap <Leader>gq gggqG

" Reformat paragraph
noremap <Leader>gp gqap

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Enclose each selected line with markers
noremap <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>

" Enable fancy % matching
if has("eval")
    runtime! macros/matchit.vim
endif

" q: sucks
nmap q: :q

" set up some more useful digraphs
if has("digraphs")
    digraph ., 8230    " ellipsis (…)
endif

if has("eval")
    " GNU format changelog entry
    fun! MakeChangeLogEntry()
        norm gg
        /^\d
        norm 2O
        norm k
        call setline(line("."), strftime("%Y-%m-%d") .
                    \ " Danny van Dyk <danny.dyk@uni-dortmund.de>")
        norm 2o
        call setline(line("."), "\t* ")
        norm $
        r! svn status | grep -v '^?' | sed -e 's,^D, -,' | cut -d\  -f2- | 
                    \ sort | sed -e 's,^\s*\(\([+-]\)\s*\)\?\(\S*\)\s*$,\2\3\,,' -e 's, \+, ,g'
                    \ -e '$s~,$~:~' | fmt -w2000
        norm kJ
        star!
    endfun
    noremap <Leader>cl :call MakeChangeLogEntry()<CR>

    " Work out include guard text
    fun! IncludeGuardText()
        let l:p = substitute(substitute(getcwd(), "/trunk", "", ""), '^.*/', "", "")
        let l:t = substitute(expand("%"), "[./]", "_", "g")
        return toupper(l:p . "_GUARD_" . l:t)
    endfun

    " Make include guards
    fun! MakeIncludeGuards()
        norm gg
        /^$/
        norm 2O
        call setline(line("."), "#ifndef " . IncludeGuardText())
        norm o
        call setline(line("."), "#define " . IncludeGuardText() . " 1")
        norm G
        norm o
        call setline(line("."), "#endif")
    endfun
    noremap <Leader>ig :call MakeIncludeGuards()<CR>

    " command aliases, can't call these until after cmdalias.vim is loaded
    au VimEnter * if exists("loaded_cmdalias") |
                \       call CmdAlias("mkdir",   "!mkdir") |
                \       call CmdAlias("git",     "!git") |
                \       call CmdAlias("upload",  "make upload") |
                \ endif
endif

" fast buffer switching
if v:version >= 700 && has("eval")
    let g:switch_header_map = {
                \ 'cc':    'hh',
                \ 'hh':    'cc',
                \ 'c':     'h',
                \ 'h':     'c',
                \ 'cpp':   'hpp',
                \ 'hpp':   'cpp' }

    fun! SwitchTo(f, split) abort
        if ! filereadable(a:f)
            echoerr "File '" . a:f . "' does not exist"
        else
            if a:split
                new
            endif
            if 0 != bufexists(a:f)
                exec ':buffer ' . bufnr(a:f)
            else
                exec ':edit ' . a:f
            endif
        endif
    endfun

    fun! SwitchHeader(split) abort
        let filename = expand("%:p:r")
        let suffix = expand("%:p:e")
        if suffix == ''
            echoerr "Cannot determine header file (no suffix)"
            return
        endif

        let new_suffix = g:switch_header_map[suffix]
        if new_suffix == ''
            echoerr "Don't know how to find the header (suffix is " . suffix . ")"
            return
        end

        call SwitchTo(filename . '.' . new_suffix, a:split)
    endfun

    fun! SwitchTest(split) abort
        let filename = expand("%:p:r")
        let suffix = expand("%:p:e")
        if -1 != match(filename, '_TEST$')
            let new_filename = substitute(filename, '_TEST$', '.' . suffix, '')
        else
            let new_filename = filename . '_TEST.' . suffix
        end
        call SwitchTo(new_filename, a:split)
    endfun

    noremap <Leader>sh :call SwitchHeader(0)<CR>
    noremap <Leader>st :call SwitchTest(0)<CR>
    noremap <Leader>ssh :call SwitchHeader(1)<CR>
    noremap <Leader>sst :call SwitchTest(1)<CR>
endif

" super i_c-y / i_c-e
if v:version >= 700 && has("eval")
    fun! SuperYank(offset)
        let l:cursor_pos = col(".")
        let l:this_line = line(".")
        let l:source_line = l:this_line + a:offset
        let l:this_line_text = getline(l:this_line)
        let l:source_line_text = getline(l:source_line)
        let l:add_text = ""

        let l:motion = "" . nr2char(getchar())
        if -1 != match(l:motion, '\d')
            let l:count = 0
            while -1 != match(l:motion, '\d')
                let l:count = l:count * 10 + l:motion
                let l:motion = "" . nr2char(getchar())
            endwhile
        else
            let l:count = 1
        endif

        if l:motion == "$"
            let l:add_text = strpart(l:source_line_text, l:cursor_pos - 1)
        elseif l:motion == "w"
            let l:add_text = strpart(l:source_line_text, l:cursor_pos - 1)
            let l:add_text = substitute(l:add_text,
                        \ '^\(\s*\%(\S\+\s*\)\{,' . l:count . '}\)\?.*', '\1', '')
        elseif l:motion == "f" || l:motion == "t"
            let l:add_text = strpart(l:source_line_text, l:cursor_pos - 1)
            let l:char = nr2char(getchar())
            let l:pos = matchend(l:add_text,
                        \ '^\%([^' . l:char . ']\{-}' . l:char . '\)\{' . l:count . '}')
            if -1 != l:pos
                let l:add_text = strpart(l:add_text, 0, l:motion == "f" ? l:pos : l:pos - 1)
            else
                let l:add_text = ''
            endif
        else
            echo "Unknown motion: " . l:motion
        endif

        if l:add_text != ""
            let l:new_text = strpart(l:this_line_text, 0, l:cursor_pos - 1) .
                        \ l:add_text . strpart(l:this_line_text, l:cursor_pos - 1)
            call setline(l:this_line, l:new_text)
            call cursor(l:this_line, l:cursor_pos + strlen(l:add_text))
        endif
    endfun

    inoremap <C-g>y <C-\><C-o>:call SuperYank(-1)<CR>
    inoremap <C-g>e <C-\><C-o>:call SuperYank(1)<CR>
endif

" tab completion
if has("eval")
    function! CleverTab()
        if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
            return "\<Tab>"
        else
            return "\<C-N>"
        endif
    endfun
    inoremap <Tab> <C-R>=CleverTab()<CR>
    inoremap <S-Tab> <C-P>
endif

"-----------------------------------------------------------------------
" abbreviations
"-----------------------------------------------------------------------

if has("eval") && has("autocmd")
    fun! <SID>abbrev_cpp()
        iabbrev <buffer> jci const_iterator
        iabbrev <buffer> jcl class
        iabbrev <buffer> jco const
        iabbrev <buffer> jdg \ingroup
        iabbrev <buffer> jdx /**<CR><CR>/<Up>
        iabbrev <buffer> jit iterator
        iabbrev <buffer> jns namespace
        iabbrev <buffer> jpr protected
        iabbrev <buffer> jpu public
        iabbrev <buffer> jpv private
        iabbrev <buffer> jsl std::list
        iabbrev <buffer> jsm std::map
        iabbrev <buffer> jss std::string
        iabbrev <buffer> jsv std::vector
        iabbrev <buffer> jsp std::shared_ptr
        iabbrev <buffer> jty typedef
        iabbrev <buffer> jun using namespace
        iabbrev <buffer> jvi virtual
    endfun

    augroup abbreviations
        autocmd!
        autocmd FileType cpp :call <SID>abbrev_cpp()
    augroup END
endif

"-----------------------------------------------------------------------
" special less.sh and man modes
"-----------------------------------------------------------------------

if has("eval") && has("autocmd")
    fun! <SID>check_pager_mode()
        if exists("g:loaded_less") && g:loaded_less
            " we're in vimpager / less.sh / man mode
            set laststatus=0
            set ruler
            set foldmethod=manual
            set foldlevel=99
            set nolist
        endif
    endfun
    autocmd VimEnter * :call <SID>check_pager_mode()
endif

"-----------------------------------------------------------------------
" plugin / script / app settings
"-----------------------------------------------------------------------

if has("eval")
    " Perl specific options
    let perl_include_pod=1
    let perl_fold=1
    let perl_fold_blocks=1

    " Vim specific options
    let g:vimsyntax_noerror=1
    let g:vimembedscript=0

    " c specific options
    let g:c_gnu=1
    let g:c_no_curly_error=1

    " eruby options
    au Syntax * hi link erubyRubyDelim Directory

    " Settings for taglist.vim
    let Tlist_Use_Right_Window=1
    let Tlist_Auto_Open=0
    let Tlist_Enable_Fold_Column=0
    let Tlist_Compact_Format=1
    let Tlist_WinWidth=28
    let Tlist_Exit_OnlyWindow=1
    let Tlist_File_Fold_Auto_Close = 1
    nnoremap <silent> <F9> :Tlist<CR>

    " Settings minibufexpl.vim
    let g:miniBufExplModSelTarget = 1
    let g:miniBufExplWinFixHeight = 1
    let g:miniBufExplWinMaxSize = 1
    " let g:miniBufExplForceSyntaxEnable = 1

    " Settings for showmarks.vim
    if has("gui_running")
        let g:showmarks_enable=1
    else
        let g:showmarks_enable=0
        let loaded_showmarks=1
    endif

    let g:showmarks_include="abcdefghijklmnopqrstuvwxyz"

    if has("autocmd")
        fun! <SID>FixShowmarksColours()
            if has('gui') 
                hi ShowMarksHLl gui=bold guifg=#a0a0e0 guibg=#2e2e2e 
                hi ShowMarksHLu gui=none guifg=#a0a0e0 guibg=#2e2e2e 
                hi ShowMarksHLo gui=none guifg=#a0a0e0 guibg=#2e2e2e 
                hi ShowMarksHLm gui=none guifg=#a0a0e0 guibg=#2e2e2e 
                hi SignColumn   gui=none guifg=#f0f0f8 guibg=#2e2e2e 
            endif
        endfun
        if v:version >= 700
            autocmd VimEnter,Syntax,ColorScheme * call <SID>FixShowmarksColours()
        else
            autocmd VimEnter,Syntax * call <SID>FixShowmarksColours()
        endif
    endif

    " Settings for explorer.vim
    let g:explHideFiles='^\.'

    " Settings for netrw
    let g:netrw_list_hide='^\.,\~$'

    " Settings for :TOhtml
    let html_number_lines=1
    let html_use_css=1
    let use_xhtml=1

    " cscope settings
    if has('cscope') && filereadable("/usr/bin/cscope")
        set csto=0
        set cscopetag
        set nocsverb
        if filereadable("cscope.out")
            cs add cscope.out
        endif
        set csverb

        let x = "sgctefd"
        while x != ""
            let y = strpart(x, 0, 1) | let x = strpart(x, 1)
            exec "nmap <C-j>" . y . " :cscope find " . y .
                        \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
            exec "nmap <C-j><C-j>" . y . " :scscope find " . y .
                        \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
        endwhile
        nmap <C-j>i      :cscope find i ^<C-R>=expand("<cword>")<CR><CR>
        nmap <C-j><C-j>i :scscope find i ^<C-R>=expand("<cword>")<CR><CR>
    endif
endif

"-----------------------------------------------------------------------
" final commands
"-----------------------------------------------------------------------

" turn off any existing search
if has("autocmd")
    au VimEnter * nohls
endif

"-----------------------------------------------------------------------
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=72                  :
