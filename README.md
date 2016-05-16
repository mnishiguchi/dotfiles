# dotfiles

## Objectives
- Manage all the dotfiles in a git repository.

## How to
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

## Reference

- [dotfilesをgithubで管理(Japanese)](http://qiita.com/himinato/items/7f5461814e8ed8916870)
