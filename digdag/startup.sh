#!/bin/sh

# digdagをインストール(http://docs.digdag.io/getting_started.html)
curl -o ~/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest"
chmod +x ~/bin/digdag
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc

digdag server --config ./etc/digdag.properties --bind 0.0.0.0 --port 65432 --task-log /var/log/digdag/ --access-log /var/log/digdag