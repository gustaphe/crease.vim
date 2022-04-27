# Crease.vim
Easy foldtext customization for [neo]vim.

## Installation
### [Vim packages](http://vimhelp.appspot.com/repeat.txt.html#packages) (since Vim 7.4.1528)

        git clone https://github.com/scr1pt0r/crease.vim ~/.vim/pack/plugins/start/crease

### [Pathogen](https://github.com/tpope/vim-pathogen)
1. Install with the following command.

        git clone https://github.com/scr1pt0r/crease.vim ~/.vim/bundle/crease.vim

2. Generate help tags with `:Helptags`.

### [Vundle](https://github.com/VundleVim/Vundle.vim)
1. Add the following configuration to your `.vimrc`.

        Plugin 'scr1pt0r/crease.vim'

2. Install with `:PluginInstall`.

### [NeoBundle](https://github.com/Shougo/neobundle.vim)
1. Add the following configuration to your `.vimrc`.

        NeoBundle 'scr1pt0r/crease.vim'

2. Install with `:NeoBundleInstall`.

### [vim-plug](https://github.com/junegunn/vim-plug)
1. Add the following configuration to your `.vimrc`.

        Plug 'scr1pt0r/crease.vim'

2. Install with `:PlugInstall`.

### [dein.vim](https://github.com/Shougo/dein.vim)
1. Add the following configuration to your `.vimrc`.

        call dein#add('scr1pt0r/crease.vim')

2. Install with `:call dein#install()`


## Features

* Vim statusline and printf like syntax, using "%" items for customizing foldtext.
* Dynamically changing foldtext based on the current foldmethod (useful when
  the foldmethod is defined in a modeline, or in a user command).

## Usage

This plugin is configured through the `g:crease_foldtext` variable. It is a
dictionary whose keys are the possible foldmethods (and `default`), and whose
values are the foldtexts for the corresponsing foldmethods.

Items starting with "%" in the foldtexts are expanded as described by the table
below. `count` can be added as a number between the "%" and the item.

| Item | Meaning                                                                                                   | Count   |
|:----:|:----------------------------------------------------------------------------------------------------------| :------ |
| %%   | A literal "%".                                                                                            | Width   |
| %=   | Seperation point between alignment sections. Each section will be seperated by an equal number of spaces. | Repeat  |
| %t   | The text in the first line of the fold, stripped of comments and fold markers.                            | Width   |
| %l   | The number of lines in the fold.                                                                          | Width   |
| %f   | The fold character defined in the fillchars option ("-" by default).                                      | Repeat  |
| %{   | Evaluate the expression between "%{" and "}" and substitute the result.                                   | Ignored |

For the fields where `Count` gives width, this (roughly) corresponds to minimum
field width in C style printing, where the field will be padded with spaces
(see `:help fprint`). Where `Count` gives repeat, Adding a count will
correspond to writing the same field `Count` times in a row.

For more information, run `:help crease`

## Examples

```vim
set fillchars=fold:‧
let g:crease_foldtext = { 'default': '+-%{repeat("-", v:foldlevel)} %l lines: %t ' }
```

![crease.vim - Default style](./.screenshots/default_style.png?raw=true)

```vim
set fillchars=fold:\    " space
let g:crease_foldtext = { 'marker': '%=- %t -%=' }
```

![crease.vim - Center aligned](./.screenshots/center_aligned.png?raw=true)

```vim
set fillchars=fold:━
let g:crease_foldtext = { 'default': '%2f┫ %t%{CreaseChanged()} ┣%=┫%2l lines ┣%2f' }

function! CreaseChanged()
    return gitgutter#fold#is_changed() ? ' *' : ''
endfunction
```

![crease.vim - Right aligned line count](./.screenshots/right_aligned_line_count.png?raw=true)

## License
This software is released under the MIT license, see LICENSE.
