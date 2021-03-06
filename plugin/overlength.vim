let g:loaded_overlength = v:true

let g:overlength#default_to_textwidth     = get(g:, 'overlength#default_to_textwidth'    , 1)
let g:overlength#default_overlength       = get(g:, 'overlength#default_overlength'      , 80)
let g:overlength#default_grace_length     = get(g:, 'overlength#default_grace_length'    , 1)
let g:overlength#highlight_to_end_of_line = get(g:, 'overlength#highlight_to_end_of_line', v:true)

highlight! OverLength ctermbg=darkgrey guibg=#8b0000

augroup overlength_autocmds
    au!
    autocmd BufEnter * call overlength#highlight()
augroup END
