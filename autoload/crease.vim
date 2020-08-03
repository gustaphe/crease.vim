" =============================================================================
" Filename: autoload/crease.vim
" Author: scr1pt0r
" License: MIT
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! crease#foldtext() abort
    if !exists('g:crease_foldtext')
        return foldtext()
    elseif has_key(g:crease_foldtext, &foldmethod)
        return s:parse_foldtext(g:crease_foldtext[&foldmethod])
    elseif has_key(g:crease_foldtext, 'default')
        return s:parse_foldtext(g:crease_foldtext.default)
    else
        return foldtext()
    endif
endfunction

function! s:parse_foldtext(foldtext) abort
    let components = split(s:parse_items(a:foldtext), '', 1)

    if len(components) == 1
        return components[0]
    endif

    let total_empty_space = s:buffer_width()
                                    \ - strdisplaywidth(join(components, ''))
    let num_fillers = len(components) - 1
    let fillers = repeat([total_empty_space / num_fillers], num_fillers)
    for i in range(
                \ num_fillers - 1,
                \ num_fillers - (total_empty_space % num_fillers),
                \ -1
                \ )
        let fillers[i] += 1
    endfor

    let foldtext = components[0]
    for i in range(num_fillers)
        let foldtext .= repeat(s:fill_char(), fillers[i]) . components[i + 1]
    endfor

    return foldtext
endfunction

function! s:parse_items(foldtext) abort
    let parsed_blocks = substitute(
        \ a:foldtext,
        \ '\m\C%{\([^{]*\)}',
        \ '\=eval(submatch(1))',
        \ 'g'
        \ )

    return substitute(
        \ parsed_blocks,
        \ '\m\C%\(.\)',
        \ '\=s:expand_item(submatch(1))',
        \ 'g'
        \ )
endfunction

function! s:expand_item(item) abort
    if a:item ==# '%'
        return '%'
    elseif a:item ==# '='
        return ''
    elseif a:item ==# 'f'
        return s:fill_char()
    elseif a:item ==# 't'
        return s:stripped_fold_text()
    elseif a:item ==# 'l'
        return v:foldend - v:foldstart + 1
    endif

    return '%' . a:item
endfunction

function! s:stripped_fold_text() abort
    return trim(substitute(
        \ getline(v:foldstart),
        \ '\V\C'
        \ . join(split(&commentstring, '%s'), '\|') . '\|'
        \ . join(split(&foldmarker, ','), '\d\?\|'),
        \ '',
        \ 'g'
        \ ))
endfunction

function! s:fill_char() abort
    let index = matchend(&fillchars, '\V\Cfold:')
    return index >= 0 ? nr2char(strgetchar(&fillchars, index)) : '-'
endfunction

function! s:buffer_width() abort
    let window_width = winwidth(0)
    let number_width = (&number || &relativenumber) ?
        \ max([&numberwidth, strdisplaywidth(line('$')) + 1]) : 0
    let fold_width = &foldcolumn
    let sign_width =
        \ &signcolumn == 'yes'
        \ || !empty(sign_getplaced(bufnr(''))[0]['signs'])
        \ || (
        \   exists('g:loaded_gitgutter')
        \   && g:loaded_gitgutter
        \   && !empty(GitGutterGetHunks())
        \ )
        \ ? 2 : 0
    return window_width - number_width - fold_width - sign_width
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
