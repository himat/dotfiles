# Very useful commands

## Avoid merge commits
This rewinds your local commits, pulls the remote ones, and then replays your local commits on top of the remote ones. No merge conflicts! (unless there are actual differences at the same locations in both local and remote files)
    git pull --rebase

