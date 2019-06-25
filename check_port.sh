#!/bin/bash

# Usage: check_port <address> <port>
# author: @prabhat.meher
 
check_port() {
if [ "$(which nc)" != "" ]; then 
    tool=nc
elif [ "$(which curl)" != "" ]; then
     tool=curl
elif [ "$(which telnet)" != "" ]; then
     tool=telnet
elif [ -e /dev/tcp ]; then
      if [ "$(which gtimeout)" != "" ]; then  
       tool=gtimeout
      elif [ "$(which timeout)" != "" ]; then  
       tool=timeout
      else
       tool=devtcp
      fi
fi
echo "Using $tool to test access to $1:$2"
case $tool in
nc) nc -v -G 5 -z -w2 $1 $2 ;;
curl) curl --connect-timeout 10 http://$1:$2 ;;
telnet) telnet $1 $2 ;;
gtimeout)  gtimeout 1 bash -c "</dev/tcp/${1}/${2} && echo Port is open || echo Port is closed" || echo Connection timeout ;;
timeout)  timeout 1 bash -c "</dev/tcp/${1}/${2} && echo Port is open || echo Port is closed" || echo Connection timeout ;;
devtcp)  </dev/tcp/${1}/${2} && echo Port is open || echo Port is closed ;;
*) echo "no tools available to test $1 port $2";;
esac

}
