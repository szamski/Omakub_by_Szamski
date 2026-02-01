#!/bin/bash

# Always install Python and Node.js as base languages
echo "Installing base languages (Python and Node.js)..."
mise use --global python@latest 2>/dev/null || true
mise use --global node@latest 2>/dev/null || true

# Install selected additional programming languages
if [[ -n "$SELECTED_LANGUAGES" ]]; then
  IFS=$'\n'
  for language in $SELECTED_LANGUAGES; do
    case "$language" in
    "Python")
      # Already installed above
      echo "Python already configured"
      ;;
    "Node.js")
      # Already installed above
      echo "Node.js already configured"
      ;;
    "Ruby")
      mise use --global ruby@latest
      mise settings add idiomatic_version_file_enable_tools ruby
      mise x ruby -- gem install rails --no-document
      ;;
    "Go")
      mise use --global go@latest
      ;;
    "PHP")
      sudo apt -y install php php-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip} --no-install-recommends
      php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
      php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
      rm composer-setup.php
      ;;
    "Elixir")
      mise use --global erlang@latest
      mise use --global elixir@latest
      mise x elixir -- mix local.hex --force
      ;;
    "Rust")
      bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
      ;;
    "Java")
      mise use --global java@latest
      ;;
    esac
  done
fi
