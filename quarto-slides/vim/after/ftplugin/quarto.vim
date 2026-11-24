" Keys for .qmd buffers. In after/ so they win over any markdown ftplugin
" mappings that Vim's quarto -> rmd -> markdown ftplugin chain brings in.
" Set g:quarto_slides_no_mappings = 1 to bind your own.
setlocal wrap linebreak textwidth=0

if get(g:, 'quarto_slides_no_mappings', 0)
  finish
endif

nmap <buffer> <localleader>p <Plug>(quarto-slides-preview)
nmap <buffer> <localleader>r <Plug>(quarto-slides-render)
nmap <buffer> <localleader>o <Plug>(quarto-slides-open)
