#!/bin/bash

# Força o modo não interativo
export DEBIAN_FRONTEND=noninteractive

# Atualiza a lista de pacotes sem interação, respondendo "sim" automaticamente
yes | sudo apt update
sleep 5  # Aguarda 5 segundos

# Atualiza todos os pacotes instalados sem interação, respondendo "sim" automaticamente
yes | sudo apt upgrade -y
sleep 5  # Aguarda 5 segundos

# Instala o Docker (caso não esteja instalado) sem interação
yes | sudo apt install -y docker.io
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
