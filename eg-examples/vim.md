# Useful vim keybindings

### Finding/Replacing
    - gD | (goto definition) Go to first occurrence of the text under cursor in this file, which will prob be the definition
    - <c-r> | To select some text and then replace it: select the text with `v`, then `y` which puts it in the default " register. Then type `:%s/` `<c-r>"` and this will insert the yanked " text right onto the command prompt!

### Folding
    - zO | Fully unfold all folds under cursor
    - zC | Fully fold all folds under cursor
    - zR | Fully unfold all folds in buffer
    - zM | Fully fold all folds in buffer

### Text movement
    - w | Go to next character of the next word
    - e | Go to last character of this word 
    - [m | Go to top of current method 
    - ]m | Go to next method after current one
    - % | Press while on a {, }, (, ), [, ] to jump to the matching one

### Change text
    - cw | Change this word until start of next word
    - ce | Change this word until the end of this word (a lot more useful than cw)
    - J | Merge current line with the next one

### Misc
    - <C-a> | Increment the next number (increment and decrement are so fun to use!)
    - <C-x> | Decrement the next number

## With my plugins and custom mappings

- <C-p> | Search for and open any file in the current project
- \b | Search through open buffer names
- \l | Search through all lines in all loaded buffers
- \h | Search through recent opened files
- \H | Search through vim command history
- \: | Search through all vim commands (includes installed plugin commands)
- \m | Search through marks
- \> | Search through tags in current file
- \. | Search through tags globally
- \? | Search through all vim help docs
