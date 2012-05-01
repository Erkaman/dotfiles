# aliasaes for making and decompressing tarballs.
alias untarball="tar xzfv"
alias tarball="tar cvzf"
alias o=exo-open
alias dark="ark --batch"

export ACLOCAL_FLAGS="-I /usr/local/share/aclocal"

NC=`cat /proc/cpuinfo | grep processor | wc -l`
alias make="make -j$NC"

function h2d { echo "obase=10; ibase=16; $( echo "$*" | sed -e 's/0x//g' -e 's/\([a-z]\)/\u\1/g' )" | bc; }
function h2b { echo "obase=2; ibase=16; $( echo "$*" | sed -e 's/0x//g' -e 's/\([a-z]\)/\u\1/g' )" | bc; }
function b2d { echo "obase=10; ibase=2; "$*"" | bc; }
function b2h { echo "0x$(echo "obase=16; ibase=2;"$*"" | bc)"; }
function d2b { echo "obase=2; ibase=10; "$*"" | bc; }
function d2h { echo "0x$(echo "obase=16; ibase=10; "$*"" | bc)"; }

alias trash="trash-put"

# just run a command and ignore all of its output.
j-open(){ nohup $1 >/dev/null 2>&1&}

just-wmg-open(){ exec o $1 >& /dev/null & }

#play-all-files(){ exec "just-open "gnome-mplayer *.mp3"" }

# makes bash match filesnames in a case insensitive manner.
shopt -s nocaseglob

PATH="$HOME/bin:~/.cabal/bin/:~/.local/bin:/usr/local/bin:$PATH"

# eternal bash history.
# source: http://blog.tonyscelfo.com/2009/04/save-all-of-your-bash-history.html
# don't put duplicate lines in the history. See bash(1) for more options
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# set the time format for the history file.
export HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
  # Show the currently running command in the terminal title:
  # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
  show_command_in_title_bar()
  {
    case "$BASH_COMMAND" in
      *\033]0*)
      # The command is trying to set the title bar as well;
      # this is most likely the execution of $PROMPT_COMMAND.
      # In any case nested escapes confuse the terminal, so don't
      # output them.
      ;;
      *)
      if test ! "$BASH_COMMAND" = "log_bash_eternal_history"
      then
        echo -ne "\033]0;$(history 1 | sed 's/^ *[0-9]* *//') :: ${PWD} :: ${USER}@${HOSTNAME}\007"
      fi
      ;;
    esac
  }
  trap show_command_in_title_bar DEBUG
  ;;
  *)
  ;;
esac

log_bash_eternal_history()
{
  command=$(history 1)
  if [ "$LOG_BASH_ETERNAL_HISTORY" ]
  then
    if [ "$command" ]
    then
      date_part=`echo $command | sed 's/^ *[0-9]* \([0-9\.]* [0-9:]*\).*/\1/'`
      command_part=`echo $command | sed 's/^ *[0-9]* [0-9\.]* [0-9:]* \(.*\)/\1/'`
      if [ "$command_part" != "$LOG_BASH_ETERNAL_HISTORY" -a "$command_part" != "ls" ]
      then
        echo $date_part $USER@$HOSTNAME $? $command_part >> ~/.bash_eternal_history
        export LOG_BASH_ETERNAL_HISTORY="$command_part"
      fi
    fi
  else
    export LOG_BASH_ETERNAL_HISTORY="LOG_BASH_ETERNAL_HISTORY_INITIALIZATION"
  fi
}

PROMPT_COMMAND="log_bash_eternal_history"

TEXMFLOCAL="/usr/local/texlive/2011/texmf/"
