" Return if there's no Python support.
if !has("python") && !has("python3")
    :echom "Vim was not compiled with Python support. Pastery cannot run."
    finish
endif

let pastery_result_url = ""

" Set default API key.
if !exists("g:pastery_apikey")
  let g:pastery_apikey = ""
endif

" Set default auto-open behavior.
if !exists("g:pastery_open_in_browser")
  let g:pastery_open_in_browser = 0
endif

" Set default copy-to-clipboard behavior.
if !has('clipboard')
  let g:pastery_copy_to_clipboard = 0
elseif !exists("g:pastery_copy_to_clipboard")
  let g:pastery_copy_to_clipboard = 1
endif

" Paste a range.
command! -range PasteCode call pastery#PasteCode(<line1>,<line2>)

" Paste a whole file.
command! PasteFile call pastery#PasteFile()

:vnoremap <f2> :PasteCode<cr>
