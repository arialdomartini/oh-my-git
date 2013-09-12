oh-my-git!
=========


![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/01-not in a git repo.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/02-in a git repo.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/03-on master.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/04-untracked-add-commit.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/05-rm.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/06-a typical session.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/07-tracking branch.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/08-explicit upstream.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/09-ahead.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/10-behind.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/11-diverge.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/12-detached.jpg)
![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/samples/13-stash.jpg)


![alt tag](https://raw.github.com/arialdomartini/oh-my-git-gh-pages/gh-pages/images/shut-up.gif)

Installation
------------

One liner for Mac:

    cd ~ && git clone https://github.com/arialdomartini/oh-my-git.git && echo source $HOME/oh-my-git/prompt.sh >> .profile


One liner for Ubuntu:

    cd ~ && git clone https://github.com/arialdomartini/oh-my-git.git && echo source $HOME/oh-my-git/prompt.sh >> .bashrc

Then, set your Terminal font to Monospace (or edit oh-my-git and change the symbols used)

Manually:

Fork the repo and git clone it in your home directory
Then add

    source $HOME/oh-my-git/prompt.sh

to the bash startup file (~/.profile on Mac, .bash_profile or .bashrc on Linux)

Known bugs and limitations
--------------------------
* It works weird on brand new repositories, before the first commit
* It has been tested on Mac only
* You need an unicode font (like Menlo or Monaco on Mac OS X, or Monospace on Ubuntu)

zsh version
-----------
Coming soon. I'm working on the integration with zsh + oh-my-zsh + antigen
Wanna help? Great! Fork it! It will be really appreciated!
