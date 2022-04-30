# My dotfiles

Clone repo and then run `./setup.sh` which will symlink files in your home directory (`~`) to these dotfiles. It will also copy your existing dotfiles in your home directory into a backup folder in case you want them back.

##### `~/.gitconfig.private`  
- The `.gitconfig` file will automatically use any configurations in the `~/.gitconfig.private` file if it exists.
- You should put personal info in this file
    - Ex. 
	```
	[user]
	    name = M Pegasus  
	    email = pegasus@industrial.illusions
	```


