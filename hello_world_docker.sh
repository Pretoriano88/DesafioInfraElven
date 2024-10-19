#!/bin/bash

# Força o modo não interativo
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Evita que qualquer interface seja exibida durante a instalação
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -q -y update
sleep 5  # Aguarda 5 segundos

# Atualiza todos os pacotes instalados sem interação
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -q -y upgrade
sleep 5  # Aguarda 5 segundos

# Instala o Docker (caso não esteja instalado) sem interação
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -q -y install docker.io
sleep 5  # Aguarda 5 segundos

# Habilita e inicia o serviço Docker
sudo systemctl enable docker
sleep 2  # Aguarda 2 segundos
sudo systemctl start docker
sleep 2  # Aguarda 2 segundos

# Cria um arquivo HTML com a mensagem "Hello World"
echo "<h1>Hello World</h1>" > index.html
sleep 2  # Aguarda 2 segundos

# Executa um container Docker utilizando nginx, montando o diretório atual com o arquivo HTML
sudo docker run -d -p 8080:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx
sleep 2  # Aguarda 2 segundos

# Exibe a mensagem de sucesso
echo "O container está rodando! Acesse no navegador: http://localhost:8080"
