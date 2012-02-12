" insertlessly.vim - Waste no more time entering insert mode just to insert enters!
" Author:       Barry Arthur <barry dot arthur at gmail dot com>
" Last Updated: 12 Feb 2012
"
" See insertlessly.txt for help.  This can be accessed by doing
"
" :helptags ~/.vim/doc
" :help insertlessly
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let g:insertlessly_version = 0.4

" Exit quickly when: {{{1
" - this plugin was already loaded or disabled
" - when 'compatible' is set
if (exists("g:loaded_insertlessly") && g:loaded_insertlessly) || &cp
  finish
endif
let g:loaded_insertlessly = 1

" Setup {{{1
let s:cpo_save = &cpo
set cpo&vim

" Options
if !exists('g:insertlessly_insert_newlines')
  let g:insertlessly_insert_newlines = 1
endif

if !exists('g:insertlessly_open_newlines')
  let g:insertlessly_open_newlines = 1
endif

if !exists('g:insertlessly_backspace_past_bol')
  let g:insertlessly_backspace_past_bol = 1
endif

if !exists('g:insertlessly_delete_at_eol_joins')
  let g:insertlessly_delete_at_eol_joins = 1
endif

if !exists('g:insertlessly_cleanup_all_ws')
  let g:insertlessly_cleanup_all_ws = 1
endif

if !exists('g:insertlessly_cleanup_trailing_ws')
  let g:insertlessly_cleanup_trailing_ws = 1
endif

if !exists('g:insertlessly_adjust_cursor')
  let g:insertlessly_adjust_cursor = 0
endif

" Auto Commands {{{1

augroup Insertlessly
  au!
  au InsertLeave * call <SID>Insertlessly_LeaveInsert()
augroup END

" Maps {{{1
nnoremap <silent> <Plug>BSPastBOL      :<c-u>call <SID>BackspacePastBOL()<CR>
nnoremap <silent> <Plug>InsertNewline  :<c-u>call <SID>InsertNewline()<CR>
nnoremap <silent> <Plug>OpenNewline    :<c-u>call <SID>OpenNewline()<CR>
nnoremap <silent> <Plug>DelAtEOL       :<c-u>call <SID>DeleteAtEOL()<CR>

if !hasmapto('<Plug>InsertNewline') && g:insertlessly_insert_newlines != 0
  nmap <Enter> <Plug>InsertNewline
endif
if !hasmapto('<Plug>OpenNewline') && g:insertlessly_open_newlines != 0
  nmap <S-Enter> <Plug>OpenNewline
endif
if !hasmapto('<Plug>BSPastBOL') && g:insertlessly_backspace_past_bol != 0
  nmap <BS> <Plug>BSPastBOL
endif
if !hasmapto('<Plug>DelAtEOL') && g:insertlessly_delete_at_eol_joins != 0
  nmap <Del> <Plug>DelAtEOL
endif

" Functions {{{1
function! s:BackspacePastBOL()
  if g:insertlessly_insert_newlines != 0
    let pos = getpos('.')
    let line = getline('.')
    if (pos[2] == 1) && (pos[1] > 1)
      if match(line, '.') != -1
        normal! kJ
      else
        normal! kgJ
      endif
    else
      normal! X
    endif
  else
    normal! X
  endif
endfunction " }}}1

function! s:InsertNewline()
  if (col('.') + 1) == col('$')
    exe "normal! " . v:count1 . "o"
  else
    exe "normal! " . v:count1 . "i\<Enter>"
  endif
endfunction

function! s:OpenNewline()
  exe "normal! " . v:count1 . "o"
  "startinsert
  "call feedkeys("\<c-o>o")
endfunction

function! s:DeleteAtEOL()
  if g:insertlessly_delete_at_eol_joins != 0
    let eol_col = col('$')
    let col = col('.')
    let eob_line = line('$')
    let line = line('.')
    if ((col == 1) && (col == eol_col)) || (((col + 1) == eol_col) && (line != eob_line))
      normal! J
    else
      exe "normal! \<del>"
    endif
  else
    exe "normal! \<del>"
  endif
endfunction

function! s:Insertlessly_LeaveInsert()
  call s:CleanupAllWhitespace()
  call s:AdjustCursor()
endfunction

function! s:CleanupAllWhitespace()
  if g:insertlessly_cleanup_all_ws != 0
    let pos = getpos('.')
    silent! %s/\s\+$//
    call setpos('.', pos)
  else
    call s:CleanupLine()
  endif
endfunction

function! s:CleanupLine()
  if g:insertlessly_cleanup_trailing_ws != 0
    let line = getline('.')
    if line =~ '\s\+$'
      call setline('.', substitute(line, '\s\+$', '', ''))
    endif
  endif
endfunction

function! s:AdjustCursor()
  if g:insertlessly_adjust_cursor != 0
    let col = col('.')
    if col != 1
      if col != (col('$') - 1)
        normal! l
      endif
    endif
  endif
endfunction

" Teardown {{{1
let &cpo = s:cpo_save

" vim:set ft=vim sw=2 sts=2 et fdm=marker:
