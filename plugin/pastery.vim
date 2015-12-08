" Return if there's no Python support.
if !has("python")
    finish
endif

" Set default API key.
if !exists("g:pastery_apikey")
  let g:pastery_apikey = ""
endif

" Paste a range.
:command -range             PasteCode :py PasteryPaste(<line1>,<line2>)
" Paste a whole file.
:command                    PasteFile :py PasteryPaste()

:vnoremap <f2> :PasteCode<cr>

python << EOF
import vim
import json
try:
    from urllib.request import urlopen, Request, build_opener
except ImportError:
    from urllib2 import urlopen, Request, build_opener

def PasteryPaste(start=None, end=None):
    if start is None:
        start = 1
    if end is None:
        end = -1

    api_key = vim.eval("g:pastery_apikey")

    data = '\n'.join(vim.current.buffer[int(start) - 1:int(end)])

    url = "https://www.pastery.net/api/paste/?language=%s" % vim.eval('&ft')
    if api_key:
        url = url + "&api_key=" + api_key
    req = Request(url,
                  data=bytes(data),
                  headers={'User-Agent': 'Mozilla/5.0 (Vim) Pastery plugin'})
    response = urlopen(req)
    if response.code != 200:
        print("Error while pasting.")
    else:
        print("Paste URL: %s" % json.loads(response.read())["url"])
EOF
