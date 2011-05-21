" insertlessly.vim - Waste no more time entering insert mode just to insert enters!
" Author:       Barry Arthur <barry.arthur@gmail.com>
" Last Updated: 29 Jul 2010
"
" See insertlessly.txt for help.  This can be accessed by doing
"
" :helptags ~/.vim/doc
" :help insertlessly
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let g:insertlessly_version = 0.1

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

" Maps {{{1
nnoremap <silent> <Plug>BSPastBOL      :<C-U>call <SID>backspacepastBOL()<CR>
nnoremap <silent> <Plug>InsertNewline  i<Enter><Esc>
nnoremap <silent> <Plug>OpenNewline    o<Esc>
nnoremap <expr> <Del> ((col('.')+1) == col('$')) ? "gJ" : "<Del>"

if !hasmapto('<Plug>InsertNewline')
  nmap <Enter> <Plug>InsertNewline
endif
if !hasmapto('<Plug>OpenNewline')
  nmap <S-Enter> <Plug>OpenNewline
endif
if !hasmapto('<Plug>BSPastBOL')
  nmap <BS> <Plug>BSPastBOL
endif

" Functions {{{1
function! s:backspacepastBOL()
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
endfunction " }}}1

" Teardown {{{1
let &cpo = s:cpo_save

" vim:set ft=vim sw=2 sts=2 et fdm=marker:
