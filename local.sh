KEY=`cat ~/.ssh/id_rsa`
docker run --rm -it --name builds -v builds:/builds -v $PWD/output:/output -v $PWD/scripts:/usr/local/sbin -e SSH_PRIVATE_KEY="$KEY" -w /builds blockswearables/aosp bash -C init.sh;bash
