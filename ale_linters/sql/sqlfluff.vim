" ale_linters/sql/sqlfluff.vim
" Author: slve <slve@gmx.com>
" Description: sqlfluff for SQL files.
"              sqlfluff can be found at
"              https://github.com/sqlfluff/sqlfluff

function! ale_linters#sql#sqlfluff#Handle(buffer, lines) abort
    " Matches patterns like the following:
    "
    " L:  39 | P:  64 | L014 | Unquoted identifiers must be consistently capitalised.
    let l:patternwarning = '\v^L:\s+(\d+)\s+\|\s+P:\s+(\d+)\s+\|\s+([^\|P]+)\s+\|\s+(.*)'
    let l:patternerror = '\v^L:\s+(\d+)\s+\|\s+P:\s+(\d+)\s+\|\s+([^\|L]+)\s+\|\s+(.*)'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:patternwarning)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'type': 'W',
        \   'text':  l:match[3] . ': ' . l:match[4],
        \})
    endfor

    for l:match in ale#util#GetMatches(a:lines, l:patternerror)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'type': 'E',
        \   'text':  l:match[3] . ': ' . l:match[4],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('sql', {
\   'name': 'sqlfluff',
\   'aliases': ['sql-fluff'],
\   'executable': 'sqlfluff',
\   'command': 'sqlfluff lint --dialect bigquery - ',
\   'callback': 'ale_linters#sql#sqlfluff#Handle',
\})
