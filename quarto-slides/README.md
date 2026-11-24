# quarto-slides

Write reveal.js slide decks as Markdown in Vim and see them in the browser as
you type. [Quarto](https://quarto.org) turns a `.qmd` file into one
self-contained `.html` deck you can present, mail or attach.

```
quarto-slides/
├── template.qmd          a lorem ipsum deck showing the useful features
├── custom.scss           theme tweaks (fonts, colors, sizes)
└── bin/slides            shell command: new, edit, preview, render, pdf
```

The Vim side (preview in a WezTerm/tmux pane, render, open) is a separate
plugin, [vimoured/quarto-slides](https://github.com/vimoured/quarto-slides).

## How the pieces fit

```
 ┌──────────── WezTerm window ─────────────┐
 │ vim slides.qmd        │ quarto preview  │ ──► browser tab, reloads
 │                       │ (pane opened by │     on every :w
 │  _p  toggle preview ──┼─► _p)           │
 │  _r  render .html     │                 │
 │  _o  open .html       │                 │
 └─────────────────────────────────────────┘
   shell: slides new talk/ && cd talk && slides edit
```

- **Shell (bash or zsh):** `slides` creates a deck from the template, picks
  one with fzf, and runs quarto.
- **Vim:** `_p` starts `quarto preview` in a pane to the right of Vim and gives
  focus back to Vim. Each `:w` re-renders the deck and reloads the browser.
  Press `_p` again to close the pane. Closing Vim also stops it.
- **WezTerm / tmux:** the plugin opens the preview pane with
  `wezterm cli split-pane` (or `tmux split-window` inside tmux). Without either,
  it runs the preview in a hidden Vim terminal (`:ls!` lists it).

## Install on a new machine

1. **Quarto:** `brew install --cask quarto` on macOS. On Linux, use the
   package from <https://quarto.org/docs/get-started/>. Check it with
   `quarto check`.
2. **Clone** this repo anywhere, for example `~/src/quarto-slides`.
3. **Shell:** put `bin/` on your PATH, in `~/.zshrc` or `~/.bashrc`, or
   link `bin/slides` into a directory already on it:

   ```sh
   export PATH="$HOME/src/quarto-slides/quarto-slides/bin:$PATH"
   ```

4. **Vim (9.1 or newer):** install the plugin, then bind its keys for `.qmd`
   buffers in `~/.vim/after/ftplugin/quarto.vim` (in `after/`, so they win
   over the markdown ftplugin's, which Vim also loads for `.qmd` files):

   ```vim
   Plug 'vimoured/quarto-slides'
   ```

   ```vim
   " ~/.vim/after/ftplugin/quarto.vim
   nmap <buffer> <localleader>p <Plug>(quarto-slides-preview)
   nmap <buffer> <localleader>r <Plug>(quarto-slides-render)
   nmap <buffer> <localleader>o <Plug>(quarto-slides-open)
   ```

Optional tools: `fzf`, `fd` and `bat` for `slides edit`; vim-dispatch, so that
`_r` renders into the quickfix list; Node.js (`npx`) for `slides pdf`.

## Use

```sh
slides new talks/2026-lorem     # slides.qmd + custom.scss from the template
cd talks/2026-lorem
slides edit                     # opens vim; with several decks, pick one with fzf
```

In Vim, with the keys bound as above (`_` is the local leader):

| Key  | Command          | What it does |
| ---- | ---------------- | ------------ |
| `_p` | `:SlidesPreview` | Toggle the live preview pane |
| `_r` | `:SlidesRender`  | Write the final `.html` (via `:Dispatch` if available) |
| `_o` | `:SlidesOpen`    | Open the rendered `.html` in the browser |
|      | `:SlidesStop`    | Stop the preview |

Settings:

```vim
let g:quarto_slides_pane_percent = 30   " preview pane width (default 25)
```

Without Vim: `slides preview`, `slides render`, `slides pdf`.

## Writing slides: cheat sheet

| Markdown | Result |
| --- | --- |
| `# Title` | Section title slide |
| `## Title` | New slide |
| `::: {.incremental}` … `:::` | Bullets appear one at a time |
| `. . .` | Pause: what follows appears on the next click |
| `:::: {.columns}` + `::: {.column width="50%"}` | Columns |
| `::: {.panel-tabset}` + `### Tab` | Tabs |
| `::: {.notes}` | Speaker notes (press `s` while presenting) |
| ```` ```{.python code-line-numbers="2-3"} ```` | Highlight code lines |
| `## Title {background-color="#e0f2fe"}` | Slide background |

While presenting: `f` full screen, `o` or `Esc` slide overview, `s` speaker
view, `?` all keys.

**Theme:** edit `custom.scss` next to the deck, or change `theme:` in the
header (`[moon, custom.scss]`, `[simple, custom.scss]`, …). See
[the list of themes](https://quarto.org/docs/presentations/revealjs/themes.html).

**PDF:** `slides pdf` uses decktape. Or open the deck in Chrome with
`?print-pdf` added to the URL and print to PDF
([reveal.js PDF export](https://revealjs.com/pdf-export/)).

## References

- <https://quarto.org/docs/presentations/revealjs/>
- <https://quarto.org/docs/presentations/revealjs/presenting.html>
- <https://quarto.org/docs/presentations/revealjs/themes.html>
- <https://revealjs.com/pdf-export/>
