function! insertlessly#cleanup_all_whitespace()
  let pos = getpos('.')
  let markpos = [ getpos("'["), getpos("']") ]
  silent! keeppatterns %s/\s\+$//
  " call histdel("search", -1)
  call setpos('.', pos)
  call setpos("'[", markpos[0])
  call setpos("']", markpos[1])
endfunction

function! insertlessly#cleanup_line()
  let lines = getline("'[", "']")
  call setline(line("'["),
        \ map(lines, "substitute(v:val, '\\s\\+$', '', '')"))
endfunction
