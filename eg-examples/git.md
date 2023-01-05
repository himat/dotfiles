# Very useful commands

## Avoid merge commits
This rewinds your local commits, pulls the remote ones, and then replays your local commits on top of the remote ones. No merge conflicts! (unless there are actual differences at the same locations in both local and remote files)
    git pull --rebase

## Stashing single individual files
    git stash -- <file name>

## Adding individual files quickly (by numeric numbers)
    git add -i # Starts interactive mode 
    2 # Choose 2: update
    1, 3, 5 # Type the file numbers that show up in front for the specific files you want to stage!
    <CR> # Press enter without typing anything to exit the Update mode 
    q # Quit and then you can push your commit or do what you want
