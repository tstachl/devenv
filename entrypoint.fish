#!/usr/bin/env fish

# decrypt the encryption key and if it works apply the dotfiles
if age --decrypt --output "$HOME/key.txt" "$(chezmoi source-path)/key.txt.age"
  chmod 600 "$HOME/key.txt"
  chezmoi apply

  if test -n "$REPO" 
    if test -e "$REPO"
      cd $REPO && git pull
    else
      git clone git@github.com:$REPO $REPO && cd $REPO
    end
  end

  exec fish
end

echo "Not allowed to use this."
exit
