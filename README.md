# Pastery Vim plugin

This is a Vim plugin for the [Pastery](https://www.pastery.net/) pastebin, the
sweetest pastebin in the world.


## Installation

You can install plugins in various ways. There's one in [the
documentation](http://vimdoc.sourceforge.net/htmldoc/usr_05.html#plugin), but
[Vundle.vim](https://github.com/gmarik/Vundle.vim) is just fantastic, so use
that.

Keep in mind that `pastery.vim` requires a version of Vim built with Python
support.

After you install the plugin, add your Pastery API key:

```vim
let g:pastery_apikey = "The API key you get from the account page."
```

You're ready to go! Open up Vim, select some code and press F2, you'll get
a pastery URL back.

## Usage

`pastery.vim` provides two functions:

```vim
" Paste the currently-selected portion of the code.
:PasteCode

" Paste the entire file.
:PasteFile
```

By default, `pastery.vim` binds a hotkey to paste the currently selected section
to F2. Just select a few lines, press that and you'll get a paste URL back very
soon. The URL will be automatically copied to your clipboard (if your vim has
clipboard support) and displayed in your vim console.

## Extended Usage

Pastery can automatically open the just-created URL for you if you want:

```vim
let g:pastery_open_in_browser = 1
```

`g:pastery_open_in_browser` defaults to 0 (false).

The latest URL is stored in a Vim variable `pastery_result_url`.

If you don't want to automatically copy the URL to the system clipboard, you
can turn the behavior off:

```vim
let g:pastery_copy_to_clipboard = 0
```

`g:pastery_copy_to_clipboard` defaults to 1 (true).

## License

This plugin is released under the BSD three-clause license.
