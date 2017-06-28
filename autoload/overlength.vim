let s:highlight_overlength = v:true

function! overlength#enable() abort
  let s:highlight_overlength = v:true
endfunction

function! overlength#disable() abort
  let s:highlight_overlength = v:false
endfunction

let s:overlength_filetype_specific_lengths = {}
function! overlength#set_overlength(filetype, length)
  let s:overlength_filetype_specific_lengths[a:filetype] = a:length
endfunction

function! overlength#get_overlength()
  if has_key(s:overlength_filetype_specific_lengths, &filetype)
    return s:overlength_filetype_specific_lengths[&filetype]
  endif

  " Different options based on default_to_textwidth
  " `0`: Don't use `&textwidth` at all. Always use `overlength#default_overlength`.
  " `1`: Use `&textwidth`, unless it's 0, then use `overlength#default_overlength`.
  " `2`: Always use `&textwidth`. There will be no highlighting where `&textwidth == 0`, unless added explicitly
  "
  " If &textwidth == 0, we just won't highlight in that filetype, that's
  " handled later though
  return overlength#default_to_textwidth > 0 ?
        \ ( (overlength#default_to_textwidth == 1 && (&textwidth > 0)
            \ || overlength#default_to_textwidth == 2) ?
              \ &textwidth
              \ : overlength#default_to_textwidth)
        \ : overlength#default_overlength
endfunction

function! overlength#set_highlight(cterm, guibg)
  call execute(printf('highlight OverLength ctermbg=%s guibg=%s', a:cterm, a:guibg))
endfunction

function! overlength#clear() abort
  if exists('w:last_overlength')
    " Just try and delete it
    " Don't worry if it messes up
    silent! call matchdelete(w:last_overlength)
    silent! unlet w:last_overlength
  endif
endfunction

function! overlength#toggle() abort
  let s:highlight_overlength = !s:highlight_overlength

  if s:highlight_overlength
    call overlength#highlight()
  else
    call overlength#clear()
  endif
endfunction

function! overlength#highlight() abort
  if overlength#get_overlength() == 0
    return
  endif

  " TODO: It doesn't really cost that much to ALWAYS clear, just to make sure
  " we're in sync... but maybe we shouldn't
  call overlength#clear()

  if s:highlight_overlength
    if !exists('w:last_overlength')
      let w:last_overlength = matchadd('OverLength', '\%' . overlength#get_overlength() . 'v.*')
    endif
  endif
endfunction

