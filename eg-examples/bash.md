# Rename parts of multiple files matching a pattern
    `for f in anything_*; do mv "$f" "${f/_oldText/_newText}"; done`

If you want to preview the changes first, then do  
    `for f in anything_*; do echo "${f/./-OLD.}"; done`
