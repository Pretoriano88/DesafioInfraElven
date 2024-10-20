#!/bin/bash

# Força o modo não interativo para evitar prompts
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Evita que qualquer interface seja exibida durante a instalação
sudo apt-get -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update

# Atualiza todos os pacotes instalados sem interação
sudo apt-get -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Predefine respostas para prompts do debconf
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

# Instala o Docker sem interação
sudo apt-get -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install docker.io

# Habilita e inicia o serviço Docker
sudo systemctl enable docker
sudo systemctl start docker

# Cria um arquivo HTML com a mensagem "Hello World"
echo "<h1>Hello World</h1>" > index.html

# Executa um container Docker utilizando nginx, montando o diretório atual com o arquivo HTML
sudo docker run -d -p 8080:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx

# Exibe a mensagem de sucesso
echo "O container está rodando! Acesse no navegador: http://localhost:8080"
