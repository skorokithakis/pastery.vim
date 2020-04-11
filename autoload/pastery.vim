let s:pyver = has("python3") ? "python3" : "python"

function pastery#PasteCode(start, end)
    exec s:pyver "PasteryPaste(" a:start "," a:end ")"
endfunction

function pastery#PasteFile()
    exec s:pyver "PasteryPaste(title='" expand('%:t') "')"
endfunction

exec s:pyver . "<< EOF"
import vim
import json
import webbrowser

try:
    from urllib.request import urlopen, Request, build_opener
    from urllib.parse import quote_plus
except ImportError:
    from urllib2 import urlopen, Request, build_opener
    from urllib import quote_plus

def to_bool(s):
  try:
    return bool(int(s))
  except ValueError:
    return bool(x.strip())

def PasteryPaste(start=None, end=None, title=""):
    if start is None:
        start = 1
    if end is None:
        end = len(vim.current.buffer)

    api_key = vim.eval("g:pastery_apikey")
    open_in_browser = to_bool(vim.eval("g:pastery_open_in_browser"))
    copy_to_clipboard = to_bool(vim.eval("g:pastery_copy_to_clipboard"))

    data = "\n".join(vim.current.buffer.range(start, end))

    url = "https://www.pastery.net/api/paste/?language=%s&title=%s" % (vim.eval('&ft'), quote_plus(title))

    if api_key:
        url = url + "&api_key=" + api_key

    req = Request(url, data=data.encode("utf8"), headers={'User-Agent': 'Mozilla/5.0 (Vim) Pastery plugin'})
    response = urlopen(req)
    if response.code != 200:
        vim.command(':redraw | echo "Error while pasting."')
    else:
        pastery_result_url = json.loads(response.read().decode("utf8"))["url"]
        vim.command(':let pastery_result_url = "{}"'.format(pastery_result_url))
        if copy_to_clipboard:
            vim.command(':let @+ = pastery_result_url')
        vim.command(':redraw | echo "Paste URL: {}"'.format(pastery_result_url))
        if open_in_browser:
            webbrowser.open(pastery_result_url)
EOF
