" =============================================================================
" Filename: plugin/crease.vim
" Author: scr1pt0r
" License: MIT
" =============================================================================

if exists('g:loaded_crease')
    finish
endif
let g:loaded_crease = 1

let s:save_cpo = &cpo
set cpo&vim

set foldtext=crease#foldtext()

let &cpo = s:save_cpo
unlet s:save_cpo
