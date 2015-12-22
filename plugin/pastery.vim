" Return if there's no Python support.
if !has("python")
    finish
endif

let pastery_result_url = ""

" Set default API key.
if !exists("g:pastery_apikey")
  let g:pastery_apikey = ""
endif

" Set default auto-open behavior
if !exists("g:pastery_open_in_browser")
  let g:pastery_open_in_browser = 0
endif

" Paste a range.
:command! -range             PasteCode :py PasteryPaste(<line1>,<line2>)
" Paste a whole file.
:command!                    PasteFile :py PasteryPaste()

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

    data = "\n".join(vim.current.buffer.range(start, end))

    url = "https://www.pastery.net/api/paste/?language=%s" % vim.eval('&ft')
    if api_key:
        url = url + "&api_key=" + api_key
    req = Request(url,
                  data=bytes(data),
                  headers={'User-Agent': 'Mozilla/5.0 (Vim) Pastery plugin'})
    response = urlopen(req)
    if response.code != 200:
        vim.command(':redraw | echo "Error while pasting."')
    else:
        pastery_result_url = json.loads(response.read())["url"]
        vim.command(':let pastery_result_url = "{}"'.format(pastery_result_url))
        vim.command(':redraw | echo "Paste URL: {}"'.format(pastery_result_url))
        if open_in_browser:
            webbrowser.open(pastery_result_url)
EOF
