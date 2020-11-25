# Useful vim keybindings

### Finding/Replacing
    - gD | (goto definition) Go to first occurrence of the text under cursor in this file, which will prob be the definition
    - <c-r> | To select some text and then replace it: select the text with `v`, then `y` which puts it in the default " register. Then type `:%s/` `<c-r>"` and this will insert the yanked " text right onto the command prompt!

### Folding
    - zO | Fully unfold all folds under cursor
    - zC | Fully fold all folds under cursor
    - zR | Fully unfold all folds in buffer
    - zM | Fully fold all folds in buffer

### Movement
    - w | Go to next character of the next word
    - e | Go to last character of this word 
    - _ | Go to first non-whitespace character in this line (same as ^, but easier to reach)
    - g_ | Go to last non-whitespace character in this line
    - [m | Go to top of current method 
    - ]m | Go to next method after current one
    - % | Press while on a {, }, (, ), [, ] to jump to the matching one
    - ; | Repeat f,t,F,T command forward
    - , | Repeat f,t,F,T command backwards

### Change text
    - cw | Change this word until start of next word
    - ce | Change this word until the end of this word (a lot more useful than cw)
    - J | Merge current line with the next one
    - gU | Make letters upper-case
    - gu | Make letters lower-case

### Misc
    - <C-a> | Increment the next number (increment and decrement are so fun to use!)
    - <C-x> | Decrement the next number

### Registers
    - <C-r><register_name> | Inserts the contents of a register into the vim cmd line!
    - "/ | Most recent search register. So if you just searched for something, and now want to replace it, you can do a substitution with this register instead of needing to retype it.
    - "" | Default register. So if you just yanked or deleted something, then you can use this to paste it.
    - "0 | Always has latest yanked text.
    - "- | Small delete register. Set by a delete/change command if the deleted text is less than one line.
    - "1 | Big delete register. Set by a delete/change command if text is more than one line.
    - "2 - "9 | Store the previous changes/deleted text, and each one's contents gets moved to the next one upon every delete/change.

### Moving vim splits around
    - <C-w>K | Move this current split to be the top-side one
    - <C-w>L | Move this current split to be the right-side one
    - <C-w>J | Move this current split to be the bottom-side one
    - <C-w>H | Move this current split to be the left-side one

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
