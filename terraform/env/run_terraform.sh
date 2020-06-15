#!/bin/bash
ENV=$1
MODULE=$2

REGION=us-east
BASEDIR=$(dirname $0)
TF_ROOT_DIR=$BASEDIR/modules
RUN_DIR=$TF_ROOT_DIR/$MODULE

TEMPLATE_FILE=$BASEDIR/terragrunt_template

TERRAGRUNT_FILE=$TF_ROOT_DIR/terragrunt.hcl
VAR_FILE=$BASEDIR/vars/$ENV

setup_template(){
  echo "Generating terragrunt template for $MODULE $ENV $REGION"
  echo "Using template for $TEMPLATE_FILE"

  rm -rf $TERRAGRUNT_FILE
  cp $TEMPLATE_FILE $TERRAGRUNT_FILE
  sed -i.bak "s/{{THE_BUCKET}}/$ENV-$MODULE/g" $TERRAGRUNT_FILE
  sed -i.bak "s/{{THE_LOCK_TABLE}}/$ENV-$MODULE/g" $TERRAGRUNT_FILE
  sed -i.bak "s/{{THE_REGION}}/$REGION/g" $TERRAGRUNT_FILE
  rm -rf $TERRAGRUNT_FILE.bak
}
setup_vars(){
  echo "Setting up vars for env:$ENV"
  rm -rf $TF_ROOT_DIR/terraform.tfvars
  cp $VAR_FILE $TF_ROOT_DIR/terraform.tfvars
}


run(){
  cd $RUN_DIR
  terragrunt apply
}

setup_template
setup_vars
run