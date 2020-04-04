#!/bin/bash
# Autor: Diego Costa - Projeto Root - 2020

# Como funciona o script
# Script deve estar em /home/"USER"/VirtualBox VMs/ "Caso contrário vai criar as VMS onde estiver"

# ./instanacia.sh NOME_do_Template NR. de instancias Nome do clone "Explicando como executar"
# ./instancia.sh Debian-10-Template 2  www-teste 


# Variaveis "($1 Nome do Template, $2 Número de Instâncias para levantar, $3 Nome da VM clone )"

VM_TEMPLATE=$1
LAUNCH=$2
NAME=$3
DATE=`date +%d-%m-%Y-%H.%M.%S`
VM_PATH=$VM_TEMPLATE
#VM_NAME=$NAME-$DATE
VM_NAME=$VM_TEMPLATE-$NAME

echo Clonando Template de: $VM_PATH 

# Criando um contador e utilizando o until, um while invertido, o loop irá repetir enquanto a condição for falsa
# Clona template e levanta quantas instâncias solicitadas
contador=$LAUNCH
until [ $contador -le 0 ]
do
 echo Faltam $contador Instâncias para levantar
 vboxmanage clonevm $VM_PATH --name="$RANDOM-$VM_NAME" --register --mode=all
 ((contador=contador-1))
done

# Inicializar a VM criada de modo Headless (Inicialização em background) 
echo "Iniciar VM em ...3"
sleep 1
echo "Iniciar VM em ..2"
sleep 1
echo "Iniciar VM em .1"
sleep 1
echo "Iniciando"
sleep 1

#vboxheadless -s $VM_NAME &
