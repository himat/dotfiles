# Basic search
(this recursively searches all subdirs too)
    rg 'some text'
    rg something

# Search only within files that match a glob
    rg --glob 'x0_*.js' 'some text'
        // or -g for short

# Don't ignore gitignore files
    --no-ignore

# What does rg ignore by default?
   - Files and directories that match glob patterns in these three categories:
		gitignore globs (including global and repo-specific globs).
		.ignore globs, which take precedence over all gitignore globs when there's a conflict.
		.rgignore globs, which take precedence over all .ignore globs when there's a conflict.
   - Hidden files and directories. (use --hidden to search these)
   - Binary files. (ripgrep considers any file with a NUL byte to be binary.)
   - Symbolic links aren't followed. 

# See only file names with matches
    rg -l 'some text'
    rg --files-with-matches 'some text' 
        // long form

# See more context lines around each match
    rg 'some text' -C 2 
        // Shows 2 lines before and after the match in the terminal output


# Search in specific file types only
    rg -t js 'some text' 
        // Searches *.js, *.jsx, *.vue files
    rg -t md text'
        // Searches *.markdown, *.md files

        // The param is not the file ext itself but rather a set of file types defined in rg
        // Prob easier to just use --glob to search for the exact extension you want

