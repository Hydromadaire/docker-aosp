docker run --rm -it --name builds -v builds:/builds -v $PWD/output:/output -v $PWD/scripts:/usr/local/sbin -w /builds blockswearables/aosp bash
