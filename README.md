# dotfiles

## Objectives
- Manage all the dotfiles in a git repository.

#### 1. Create the `~/dotfiles` directory
#### 2. Move the files into the `~/dotfiles` directory

```bash
$ cd ~/
$ mkdir dotfiles
$ mv .bash_profile dotfiles
```

#### 3. Create a symbolic link for each file (`~/dotfiles/ln_dotfiles.sh`)

```bash
#!/bin/sh
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
```

## References

- [dotfilesをgithubで管理(Japanese)](http://qiita.com/himinato/items/7f5461814e8ed8916870)
- [The Linux Command Line by William E. Shotts, Jr.](http://wiki.lib.sun.ac.za/images/c/ca/TLCL-13.07.pdf) - 13 - Customizing The Prompt

## Further reading
- https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
- http://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
- http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
- https://dotfiles.github.io/
- https://github.com/thoughtbot/dotfiles
