#!/usr/bin/env fish

# decrypt the encryption key and if it works apply the dotfiles
if age --decrypt --output "$HOME/key.txt" "$(chezmoi source-path)/key.txt.age"
  chmod 600 "$HOME/key.txt"
  chezmoi apply
  exec fish
end

echo "Not allowed to use this."
exit
