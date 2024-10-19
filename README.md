
Documentação da Solução de Alta Disponibilidade e Escalabilidade
I. Visão Geral da Arquitetura
A solução implementada no repositório desafioTerraform foi projetada para atender a requisitos críticos de alta disponibilidade e escalabilidade, utilizando os serviços da AWS. O foco principal é a implantação de um ambiente WordPress robusto que possa lidar com variações de tráfego e garantir desempenho otimizado.

II. Componentes Principais da Solução
Instâncias EC2: As instâncias EC2 são utilizadas para rodar o WordPress, organizadas em um grupo de Auto Scaling. Isso assegura que, conforme a demanda aumenta, novas instâncias podem ser lançadas automaticamente. Quando a demanda diminui, instâncias não necessárias são encerradas, otimizando custos.

Amazon RDS: O banco de dados relacional Amazon RDS é configurado para suportar o WordPress, utilizando a funcionalidade Multi-AZ para replicação automática em diferentes zonas de disponibilidade. Isso garante que o banco de dados permaneça disponível mesmo em caso de falha de uma zona.

Memcached: A solução incorpora o Memcached para caching em nível de aplicação, reduzindo a latência nas respostas do servidor e diminuindo a carga no banco de dados RDS. Isso melhora significativamente o desempenho, especialmente durante picos de tráfego.

Instância EC2 Privada com Docker: Uma instância EC2 privada é configurada para executar contêineres Docker, que podem hospedar serviços auxiliares ou aplicações adicionais. O uso de Docker facilita a implantação e a escalabilidade de serviços, além de garantir que as aplicações sejam isoladas e fáceis de gerenciar.

III. Segurança e Acesso
VPN Pritunl: O acesso à instância EC2 privada é controlado através de uma VPN configurada com Pritunl, que fornece uma conexão segura para usuários autorizados. Isso garante que somente indivíduos com as credenciais apropriadas possam acessar recursos sensíveis na rede privada.

Security Groups: Os grupos de segurança são configurados para restringir o tráfego de entrada e saída das instâncias, permitindo apenas as portas necessárias para operação (como HTTP, HTTPS e SSH).

IV. Monitoramento e Alertas
Amazon CloudWatch: A implementação do Amazon CloudWatch permite o monitoramento contínuo de métricas críticas, como utilização de CPU e disponibilidade das instâncias. Alarmes são configurados para notificar sobre condições que podem afetar a performance, como alta utilização da CPU (thresholds de 70% para EC2 e 75% para RDS) e falhas de status das instâncias.

Políticas de Auto Scaling: As políticas de escalonamento são baseadas nas métricas monitoradas. Por exemplo, quando a utilização da CPU excede o limite configurado, uma ação de escalonamento para aumentar a capacidade é disparada, garantindo que a aplicação continue a operar sem degradação de desempenho.

V. Decisões de Arquitetura
A escolha dos componentes da solução foi guiada pela necessidade de criar um ambiente que não apenas atendesse a requisitos de desempenho e disponibilidade, mas também fosse econômico e fácil de gerenciar. O uso de Auto Scaling, RDS com Multi-AZ e Memcached reflete uma abordagem proativa para garantir que a aplicação possa escalar de acordo com a demanda, enquanto a segurança é garantida através da implementação de uma VPN e do controle de acesso via grupos de segurança.

VI. Conclusão
A arquitetura proposta não apenas cumpre os requisitos de alta disponibilidade e escalabilidade, mas também otimiza o desempenho com caching e implementa segurança robusta através do uso de VPNs e instâncias privadas. A solução está alinhada com as melhores práticas de arquitetura na nuvem, proporcionando uma base sólida para aplicações críticas na AWS.
# DesafioInfraElven
# DesafioInfraElven
