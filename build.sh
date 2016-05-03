#!/bin/sh
root=`pwd`

exec_cmd()
{
    $1
    if [ $? -ne 0 ]; then
        echo "ERROR - $1 failed!"
        if [ "$2" == "clear" ]; then
            rm -rf $root/dist
        fi
        exit 1
    fi
}


cd $root
mkdir -p dist/pip

#Prepare pip wheels
docker rm -f pip-instance
docker rmi -f pip-binary
exec_cmd "docker build -t pip -f dockerfiles/pip.df ."
exec_cmd "docker create --name pip-instance pip"
exec_cmd "docker cp pip-instance:/wheelhouse $root/dist/pip/"
docker rm -f pip-instance

exec_cmd "docker build -t pip-binary -f dockerfiles/binary.df ."
