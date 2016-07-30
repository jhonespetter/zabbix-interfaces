# Zabbix
Zabbix Templates

== Template-Interfaces-Linux_pfSense_vX
Template-Interfaces-Linux_pfSense_v1 - 28/06/2016
- Agent: Agent Zabbix
- Applications: Interfaces de rede | SpeedTest
- Itens: SpeedTest Download | SpeedTest Upload | Gateway default | Latencia Iface | Latencia Google | Packet Loss
- Triggers: Latencia Iface | Packet Loss
- Graphs: Latencia Google | Latencia Iface | SpeedTest

== Alteração | Incremento

== Links
https://github.com/sivel/speedtest-cli
http://ipecho.net/plain

== Descrição 
- Template destinado a trazer informações de rede de firewall.

== Itens
SpeedTest Download: Teste download com speedtest-cli.
SpeedTest Upload: Teste upload com speedtest-cli.
Gateway default: Retorna qual ip do gateway default setado no firewall.
Latencia Iface: Retornar a latencia, setando uma origem. No pfSense informando origem ip da wan e no Linux origem interface wan. 
Latencia Google: Retorna perf enviado no google.
Packet Loss: Retorna porcentagem de perca de pacote saindo do gateway default para um destino.

== OS Validado
- Linux CentOS 7 | pfSense 2.3 

== Configuração do Zabbbix Server
zabbix_server.conf
Timeout=30

== Configuração do Zabbix Agent
zabbix_agentd.conf
Timeout=30
UnsafeUserParameters=1

== Macros
{$GOOGLE1} = 8.8.8.8
{$IFACE_OR_IP} = 8.8.8.8 | em0
{$DESTINO} = 8.8.8.8

== UserParameter Linux
UserParameter=packet.loss[*],/bin/ping -q -n -c 5 $1 | grep "packet loss" | cut -d " " -f 6 | cut -d "%" -f1
UserParameter=latencia.iface[*],/bin/ping -I $1 -q -n -c 5 $2 | grep rtt | cut -d"/" -f5
UserParameter=gateway.default[*],curl -s http://ipecho.net/plain
UserParameter=speedtest.upload[*],/usr/bin/speedtest-cli --bytes --simple | grep "Upload:" | cut -d " " -f2
UserParameter=speedtest.download[*],/usr/bin/speedtest-cli --bytes --simple | grep "Download:" | cut -d " " -f2

== UserParameter pfSense
UserParameter=packet.loss[*],/bin/ping -q -n -c 5 $1 | grep "packet loss" | cut -d " " -f 6 | cut -d "%" -f1
UserParameter=latencia.iface[*],/bin/ping -I $1 -q -n -c 5 $2 | grep rtt | cut -d"/" -f5
UserParameter=gateway.default[*],curl -s http://ipecho.net/plain
UserParameter=upload[*],/usr/bin/speedtest-cli --bytes --simple | grep "Upload:" | cut -d " " -f2
UserParameter=download[*],/usr/bin/speedtest-cli --bytes --simple | grep "Download:" | cut -d " " -f2

== A desenvolver
- speedtest.* setar ip de origem: speedtest-cli --bytes --simple --source
- packet.loss setar ip/iface de origem
- verificar e acertar macros para melhor uso nas keys, alterar descrição de macro para $1
- lld enderecos ips
- analisar e verificar melhor forma de encapsular todos UserParameter, no caso em uma estrutura de um shell script e organizar num include