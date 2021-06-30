#!/bin/bash

set -eou pipefail


SPLIT_COMMAND=gsplit
if [[ "$OSTYPE" == "darwin"* ]]; then
    SPLIT_COMMAND=gcsplit
    which $SPLIT_COMMAND
    if [[ $? == 1 ]]; then
        echo "Please install gcsplit"
        echo "brew install coreutils"
        exit
    fi
fi



# This is the script that allows to avoid the restrictions from the controller-gen tool that puts both Role and ClusterRole
# to the same role.yaml file (and kustomize doesn't provide an easy way to use only a single resource from file as a base)
# So we simply split the 'config/rbac/roles.yaml' file into two new files
$SPLIT_COMMAND config/rbac/role.yaml '/---/' '{*}' &> /dev/null
rm xx00
mv xx01 config/rbac/clusterwide/role.yaml
mv xx02 config/rbac/namespaced/role.yaml
rm config/rbac/role.yaml
