#!/bin/sh

# Initializes the Red Hat JBoss middleware SOE

#set -x

CURRENT=$(pwd)

echo "======================================================================================================"
echo " Create and start the virtual machine(s) ..."
cd ${CURRENT}/vagrant
vagrant up host-dev-eap-01
vagrant up nexus


echo "======================================================================================================"
echo " Build Red Hat Golden Images ..."
ansible-playbook local.yml


echo "======================================================================================================"
echo " Download and build Java applications ..."
cd ${CURRENT}/bin/java_applications
./build.sh


# Backup and removes the ssh known_hosts (prevents issues with ssh)
mv -n ~/.ssh/known_hosts{,_$(date +%s).orig}

echo "======================================================================================================"
echo " Provision the virtual machine(s) with ansible..."
cd ${CURRENT}
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory/hosts-dev site.yml

echo "======================================================================================================"
echo " Congratulations, you just setup your Red Hat JBoss middleware successfully!"
echo " "
echo " Check the running applications here:"
echo "    http://192.168.0.101:8080/ticket-monster/"
echo "    http://192.168.0.101:9080/petclinic/"
echo "    http://192.168.0.101:10080/jenkins/"
echo " "
echo " Execute this command for running Ansible again:"
echo "     $ ansible-playbook -i inventory/hosts-dev site.yml"
echo "======================================================================================================"
