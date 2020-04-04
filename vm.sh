#!/bin/sh
# Autor: Diego Costa - Projeto Root - 2020
# Inspirado em script já disponível na internet, apenas coloquei algumas adaptações.

# Como funciona o script
# Script deve estar em /home/"USER"/VirtualBox VMs/ "Caso contrário vai criar as VMS onde estiver"

# ./vm.sh NOME_VM TIPO_VERSAO   MEMORIA  DISCO   CAMINHO/ISO.iso "Explicando como executar"
# ./vm.sh vm1     Debian_64     1024     32000  /home/diegocosta/Downloads/debian-10.iso

# Variaveis "($1 Nome da VM, $2 Tipo do SO, $3 Memoria, $4 HD, $5 Caminho da ISO, Caminho da maquina .vdi - Virtual Disk Image, IFACE1=Interface com fio, IFACE2=Interface sem fio)"

VM_NAME=$1
OS_TYPE=$2
MEMORY_SIZE=$3
HDD_SIZE=$4
DVD_PATH=$5
HDD_PATH=$VM_NAME/$VM_NAME.vdi
IFACE1=enps0
IFACE2=wlp3s0

# Criando a VM e definições de Hardware virtual "podem ser ajustados conforme necessidade"

VBoxManage createvm -name $VM_NAME -ostype $OS_TYPE --register

VBoxManage modifyvm $VM_NAME \
    --memory $MEMORY_SIZE \
    --vram 16 \
    --pae off \
    --rtcuseutc on \
    --nic1 bridged --bridgeadapter1 $IFACE1 \
    --nic2 bridged --bridgeadapter2 $IFACE2 \
    --mouse usbtablet \
    --usb on \
    --usbehci on \
    --acpi on \
    --apic on \
    --autostart-enabled on \
    --graphicscontroller vmsvga


# Cria arquivo vdi no caminho e tamanho informados no shell, faz a identificação de IDE e SATA e por último adiciona na VM (Attached)  
VBoxManage createvdi --filename $HDD_PATH --size $HDD_SIZE

VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata

VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $DVD_PATH
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $HDD_PATH

# Inicializar a VM criada de modo Headless (Inicialização em background) 
echo "Iniciar VM em ...3"
sleep 1
echo "Iniciar VM em ..2"
sleep 1
echo "Iniciar VM em .1"
sleep 1
echo "Iniciando"
sleep 1

vboxheadless -s $VM_NAME &
