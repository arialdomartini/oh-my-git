
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/01-ordinary-prompt.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/02-bang.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/03-useful-information.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/04-untracked-files.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/06-rm-commit.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/06-tris-colors.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/07-tracking-branches.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/08-push-rebase-and-remote-branch-names.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/09-you-can-push.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/10-you-are-behind-fast-forward.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/11-diverged.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/12-detached.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/13-stash-and-tag.jpg)
![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/14-action-in-progress.jpg)


![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/shut-up.gif)


# Installation
## <a name="install-the-font"></a>The Font

oh-my-git is shipped with 3 themes. The one showed above is called [oppa-lana-style](https://github.com/arialdomartini/oh-my-git-themes/blob/oppa-lana-style/oppa-lana-style.zsh-theme). It's based on the [Awesome-Terminal-Fonts](https://github.com/gabrielelana/awesome-terminal-fonts) by [@gabrielelana](https://github.com/gabrielelana). The screenshots above use the font [Source Code Pro](https://github.com/adobe/Source-Code-Pro) by Adobe patched to include additional glyphs from [Powerline](https://github.com/powerline/powerline) and from Awesome-Terminal-Fonts, but you can choose any other of the Awesome-Terminal-Fonts.

You can freely [download](https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched) the fonts from the original repo.

To install one of the fonts, on macOS just double click on the corresponding ```ttf``` file and click on ```Install font```. So far, I didn't find a way to make the fallback strategy work on macOS.

On Linux you can either [install the patched font](#install-the-patched-font) or you can apply the Awesome-Terminal-Fonts [fallback strategy](https://github.com/gabrielelana/awesome-terminal-fonts/blob/master/README.md#patching-vs-fallback).
    
Then, configure your terminal with the desired font, and restart it.

## Bash

One liner for macOS:

    git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~/.profile

One liner for Ubuntu:

    git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~/.bashrc

Then restart your Terminal.


## Manual installation

Fork the repo and git clone it in your home directory.

Then add

    source $HOME/oh-my-git/prompt.sh

to the bash startup file (`~/.profile` on Mac, `~/.bashrc` on Linux)

If you prefer to keep oh-my-git repository in a different directory, just modify the startup file accordingly to the chosen position

    source /wherever-you-want/oh-my-git/prompt.sh

## zsh

With antigen installed, just add

    antigen use oh-my-zsh
    antigen bundle arialdomartini/oh-my-git
    antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

to your `.zshrc` file.

[`oh-my-git-themes`](https://github.com/arialdomartini/oh-my-git-themes) still includes the old 2 themes [arialdo-granzestyle](https://github.com/arialdomartini/oh-my-git-themes/blob/master/arialdo-granzestyle.zsh-theme)  (which is inspired to the great [Granze theme](https://github.com/Granze/G-zsh-theme-2)) by [@granze](https://github.com/granze), and [arialdo-pathinline](https://github.com/arialdomartini/oh-my-git-themes/blob/master/arialdo-pathinline.zsh-theme). If you want to use them, edit accordingly your ```.zshrc``` file.

## How to install antigen

[antigen](https://github.com/zsh-users/antigen) is a plugin manager for `zsh`.
Installing antigen is straightforward:

    cd ~ && git clone https://github.com/zsh-users/antigen.git .antigen 

Then, edit your `.zshrc` file including

    source "$HOME/.antigen/antigen.zsh"

    antigen use oh-my-zsh
    antigen bundle arialdomartini/oh-my-git
    antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

    antigen apply

When you restart zsh, antigen will download and install all that's needed.

# Customizing symbols

You can easily change any symbols used by the prompt. Take a look to the file [prompt.sh](https://github.com/arialdomartini/oh-my-git/blob/master/prompt.sh) (or to [oppa-lana-style.zsh-theme](https://github.com/arialdomartini/oh-my-git-themes/blob/master/oppa-lana-style.zsh-theme) if you use zsh). You will find a bunch of variables, each of them with its default value. The variables names should be auto-explanatory. Something like

```
: ${omg_is_a_git_repo_symbol:='❤'}
: ${omg_has_untracked_files_symbol:='∿'}
: ${omg_has_adds_symbol:='+'}
: ${omg_has_deletions_symbol:='-'}
: ${omg_has_cached_deletions_symbol:='✖'}
: ${omg_has_modifications_symbol:='✎'}
: ${omg_has_cached_modifications_symbol:='☲'}
: ${omg_ready_to_commit_symbol:='→'}
: ${omg_is_on_a_tag_symbol:='⌫'}
```

You can override any of those variables in your shell startup file.

For example, just add a

```
omg_is_on_a_tag_symbol='#'
```

to your `.bashrc` file, and oh-my-git will use `#` when you are on a tag.


# Disabling oh-my-git
oh-my-git can be disabled on a per-repository basis. Just add a

    [oh-my-git]
    enabled = false

in the `.git/config` file of a repo to revert to the original prompt for that particular repo. This could be handy when working with very huge repository, when the git commands invoked by oh-my-git can slow down the prompt.

# Uninstall

## Bash
* Remove the line `source ~/.oh-my-git/prompt.sh` from the terminal boot script (`.profile` or `.bash_rc`)
* Delete the oh-my-git repo with a `rm -fr ~/.oh-my-git`

## zsh
Remove the lines

```
antigen use oh-my-zsh
antigen bundle arialdomartini/oh-my-git
antigen theme arialdomartini/oh-my-git-themes oppa-lana-style
```

from your `.zshrc` file

# Troubleshooting

#### Help, I installed oh-my-git but this is what I see:


![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/bad-font.png)

**A**: It's likely that you forgot to [install the font](#install-the-font).

---

#### I don't want to install a new font!

**A**: "No prob. You may select [another theme](https://github.com/arialdomartini/oh-my-git-themes), or you can customize symbols. Take a look to the [prompt.sh](https://github.com/arialdomartini/oh-my-git/blob/master/prompt.sh) file. It contains a list of pre-defined symbols, similar to:

    # Symbols
    : ${omg_is_a_git_repo_symbol:='❤'}
    : ${omg_has_untracked_files_symbol:='∿'}
    : ${omg_has_adds_symbol:='+'}
    : ${omg_has_deletions_symbol:='-'}
    : ${omg_has_modifications_symbol:='✎'}

Those are just default values. If you wish to use another glyph for untracked file, just define a

    omg_has_untracked_files_symbol="whatever"

in your shell startup file.

---
#### With Bash the last symbol looks very bad, like this

![oh-my-git](https://cloud.githubusercontent.com/assets/6009528/6031476/0b9bfe2c-ac00-11e4-898a-324a71be6cb5.png)

**A**: Unfortunately, I haven't find a way to tell bash "*print the next symbol using the background color currently used by the terminal*" and as far as I know [there's no way to achieve this result](http://unix.stackexchange.com/questions/1755/change-the-ps1-color-based-on-the-background-color#tab-top). Zsh is not affected by this issue, but bash is.

As a consequence, when printing the last symbol, oh-my-git has no choice but setting explicitly the foreground and background colors. Currently, the standard background color is black. This is unfortunate, because if the terminal uses a different background color than black, the result is bad, as showed in the above screenshot.

A smart solution is the one proposed by [@Sgiath](https://github.com/Sgiath): in the color palette set the first color (the one in the top-left corner) same as background color, like this

![oh-my-git](https://cloud.githubusercontent.com/assets/6009528/6039646/454c965e-ac69-11e4-8f80-37425181d04b.png)

This in fact sets the "black" color to the same color used as the terminal background.


If for any reasons you cannot change the palette, you can override the colors used to render the last symbol with the variable `omg_last_symbol_color`.

For example, if the terminal is using a gray background, you can add a

```
background=240
red='\e[0;31m'
omg_last_symbol_color="${red}\[\033[48;5;${background}m\]"
```

to your `.bashrc` and fix the issue by choosing the right value for `background`.

You can use

```
foreground=160
background=240
omg_last_symbol_color="\[\033[38;5;${foreground}m\]\[\033[48;5;${background}m\]"
```

if you want a more detailed control on the colors.

Finding the right value is not trivial. Please, refer to [this page](http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux) for a the 256 colors code table.

---

#### On OS X, I configured iTerm2 with the patched font, but the prompt is still broken.

**A**: iTerm2 preferences have 2 sections for setting the font: one for `Regular Font` and one for `Non-ASCII Font`.
The font should be set on both the sections, like showed in the following screenshot:

![iTerm2 Preferences Page](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/iterm2.png)

---

#### <a name="install-the-patched-font"></a>Help! On Linux I can't install the font!

**A**: You should refer to the documentation of [Awesome-Terminal-Fonts](https://github.com/gabrielelana/awesome-terminal-fonts). Anyway, this is how I personally setup the prompt on Ubuntu

    # Copy the awesome fonts to ~/.fonts
    cd /tmp
    git clone http://github.com/gabrielelana/awesome-terminal-fonts
    cd awesome-terminal-fonts
    git checkout patching-strategy
    mkdir -p ~/.fonts
    cp patched/*.ttf ~/.fonts

    # update the font-info cache
    sudo fc-cache -fv ~/.fonts

Then, run ```gnome-terminal``` (or whatever terminal you like) and select one of the awesome-fonts

![alt tag](https://raw.githubusercontent.com/arialdomartini/oh-my-git-gh-pages/master/images/samples/gnome-terminal.png)

Finally, install oh-my-zsh with the one-liner (if you use Bash) or with Antigen if you love zsh, and restart the Terminal.

---

#### When I'm not in a git repo, I want to use my old, beloved prompt...

**A**: Sure! Use the variable `omg_ungit_prompt`. Store there your old prompt: it will be used when you are not in a git repo.

---

#### Help! I used the one-liner for OS X, but the prompt doesn't start!

**A**: The one-liner for OS X adds the startup command in ```~/.profile```, which is the startup file for generic login shells. If a ```~/.bash_profile``` is present, this is used in place of ```.profile```, and ```.profile``` itself is ignored. To solve your issue, use this alternative one-liner

    cd ~ && git clone https://github.com/arialdomartini/oh-my-git.git && echo source $HOME/.oh-my-git/prompt.sh >> .bash_profile

or just move the startup command

    echo source $HOME/oh-my-git/prompt.sh

from ```.profile``` to ```.bash_profile```

---

#### Hey, where's my current virtualenv name? It disappeared from the prompt! Or it appears like this

![virtualenv badly rendered](https://cloud.githubusercontent.com/assets/150719/5852434/06933e88-a217-11e4-81a0-153c5a300b0a.png)

**A**: Yes, actually the virtualenv's approach with prompts is pretty disappointing (see [Virtualenv's bin/activate is Doing It Wrong](https://gist.github.com/datagrok/2199506)): in fact, the script ```activate``` performs a

```
PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"
```

that arrogantly prepends the virtualenv name to the current ```PS1```, leaving you no opportunity to customise the output.

You can solve this problem disabling the standard virtualenv prompt injection and using the callback function `omg_prompt_callback`.

Add

```
VIRTUAL_ENV_DISABLE_PROMPT=true
function omg_prompt_callback() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "\e[0;31m(`basename ${VIRTUAL_ENV}`)\e[0m "
    fi
}
```

to your shell startup script. It should render the prompt inside an active virtualenv like this

![a proper virtualenv rendering](https://cloud.githubusercontent.com/assets/150719/5852429/e50d18a6-a216-11e4-9b0e-c902f47a1ca4.png)]

You can use the call back function to inject whatever you want at the beginning of the second line.

# Known bugs and limitations

* git v1.8.4 or newer is required
* It works weird on brand new repositories, before the first commit
* It has been tested on Mac and Ubuntu only. I never managed to make it work on Cygwin
* Depending on the theme selected, you need an unicode font (like Sauce Code Pro, Menlo or Monaco on Mac OS X, or Monospace on Ubuntu; on Windows, with Cygwin, a good choice is [Meslo](https://github.com/andreberg/Meslo-Font) by [André Berg](https://github.com/andreberg), but I didn't tested the ooppa-lana-style theme)
* If the Terminal uses a clear background color, in Bash you need to change the colors defined in [prompt.sh](https://github.com/arialdomartini/oh-my-git/blob/oppa-lana-style/prompt.sh). The zsh version is not affected by this problem.
