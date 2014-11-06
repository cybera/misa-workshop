#! /bin/bash

source ~/calgary/sandbox/openrc.sh

result=$(nova boot --flavor m1.small --image ubuntu-trusty --key-name sandbox webserver)
echo "building virtual machine..."
status=$(nova list | grep webserver)
while [[ $status != *ACTIVE* ]]; do
        echo "wait for it..."
        sleep 5
        status=$(nova list | grep webserver)
done
sleep 3
nova add-floating-ip webserver 209.97.197.164

status=$(ssh -i ~/calgary/sandbox/sandbox.pem ubuntu@209.97.197.164 "ls")
while [ $? -ne 0 ]; do
        echo "almost there..."
        sleep 2
        status=$(ssh -i ~/calgary/sandbox/sandbox.pem ubuntu@209.97.197.164 "ls")
done

ssh -i ~/calgary/sandbox/sandbox.pem ubuntu@209.97.197.164 "sudo apt-get install -y apache2"
scp -i ~/calgary/sandbox/sandbox.pem ~/Desktop/misa-webpage.html ubuntu@209.97.197.164:~/
ssh -i ~/calgary/sandbox/sandbox.pem ubuntu@209.97.197.164 "sudo cp /home/ubuntu/misa-webpage.html /var/www/html/index.html"

echo -e "\n\n\n\nTa-dah!\n\n\n\n\n\n\n\n"
