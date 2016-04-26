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

if has("python3")
    " Paste a range.
    :command! -range             PasteCode :py3 PasteryPaste(<line1>,<line2>)
    " Paste a whole file.
    :command!                    PasteFile :py3 PasteryPaste()
else
    :command! -range             PasteCode :py PasteryPaste(<line1>,<line2>)
    :command!                    PasteFile :py PasteryPaste()
endif

:vnoremap <f2> :PasteCode<cr>

python << EOF
import vim
import json
import webbrowser

try:
    from urllib.request import urlopen, Request, build_opener
except ImportError:
    from urllib2 import urlopen, Request, build_opener

def to_bool(s):
  try:
    return bool(int(s))
  except ValueError:
    return bool(x.strip())

def PasteryPaste(start=None, end=None):
    if start is None:
        start = 1
    if end is None:
        end = len(vim.current.buffer)

    api_key = vim.eval("g:pastery_apikey")
    open_in_browser = to_bool(vim.eval("g:pastery_open_in_browser"))
    copy_to_clipboard = to_bool(vim.eval("g:pastery_copy_to_clipboard"))

    data = "\n".join(vim.current.buffer.range(start, end))

    url = "https://www.pastery.net/api/paste/?language=%s" % vim.eval('&ft')
    if api_key:
        url = url + "&api_key=" + api_key
    req = Request(url, data=bytes(data), headers={'User-Agent': 'Mozilla/5.0 (Vim) Pastery plugin'})
    response = urlopen(req)
    if response.code != 200:
        vim.command(':redraw | echo "Error while pasting."')
    else:
        pastery_result_url = json.loads(response.read())["url"]
        vim.command(':let pastery_result_url = "{}"'.format(pastery_result_url))
        if copy_to_clipboard:
            vim.command(':let @+ = pastery_result_url')
        vim.command(':redraw | echo "Paste URL: {}"'.format(pastery_result_url))
        if open_in_browser:
            webbrowser.open(pastery_result_url)
EOF
