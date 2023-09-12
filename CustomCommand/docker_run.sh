#!/bin/bash

DOCKER_IMG=""
DOCKER_CON=""
SELECT_VAL=""
CONTAINER_KEYWORD="nvcr"
CONTAINER_NAME="${CONTAINER_KEYWORD}"
timeout=5
TXT_L_R=$(tput setab 4)
TXT_NORMAL=$(tput sgr0)

# Get array of images/containers
mapfile -t ARR_IMG < <(docker images | grep ${CONTAINER_KEYWORD} | awk '{print $1 ":" $2}')
mapfile -t ARR_CON < <(docker ps -a | grep ${CONTAINER_KEYWORD} | awk '{print $(NF)}')

function echoHightlight {
  echo "${TXT_L_R}$@${TXT_NORMAL}"
}

function Select {
  local arr=("$@")
  if [ ${#arr[@]} -eq 0 ]  # No entry found
  then
    echo "'${CONTAINER_KEYWORD}' not found!"
    exit 1
  elif [ ${#arr[@]} -eq 1 ]  # Only one image, use by default
  then
    echo "Found only one: ${arr}"
    SELECT_VAL=${arr}
    return 0
  fi

  echo "---------------------------"
  printf "Index\t ======\t Name\n"
  # Loop over each index
  for idx in "${!arr[@]}"
  do
    printf "${idx}\t ======\t ${arr[$idx]}\n"
  done

  # Read the choice
  read -p "Please select one image in $timeout secs: " -t $timeout idx_select
  # Default choice behaviour
  if [ -z "$idx_select" ]
  then
    echo "Select nothing, using first by default"
  else
    echo #"You selected $idx_select"
  fi
  SELECT_VAL=${arr[$idx_select]}
}

# Generate container name without conflict
function ContainerNameNonconflict {
  local basename=$1
  local name="$basename"
  local i=0
  # check the name is conflict
  while true
  do
    docker inspect $name 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ] # Found container with name
    then
#      echo Container with \"$name\" is found!
      name="${basename}_`date -I`_$i"
      i=$(( $i + 1 ))
    else
#      echo \"$name\" can be used!
      echo "$name"
      break
    fi
  done
}

# Select which image to use
Select "${ARR_IMG[@]}"
DOCKER_IMG=$SELECT_VAL
echo -n "[Choice made] Using image: " && echoHightlight "$DOCKER_IMG"
# Select which container
Select "${ARR_CON[@]}"
DOCKER_CON=$SELECT_VAL
echo -n "[Choice made] Using container: " && echoHightlight "$DOCKER_CON"

CONTAINER_NAME_NEW="$(ContainerNameNonconflict $CONTAINER_NAME)"

# Test for menu select
#exit 0

# https://github.com/pytorch/pytorch/issues/2244#issuecomment-318864552
# --shm-size 8G

# SHAREDSRC=$(readlink -f /home/daochens/docker/nginx/)
SHAREDSRC="/data/mingx/dist/paper-app/"
# 
# #NVIDIA_VISIBLE_DEVICES=all
# 
# Start container
echo nvidia-docker run --rm \
  -it \
  --name ${CONTAINER_NAME_NEW} \
  --shm-size 8G \
  -v ${SHAREDSRC}:/usr/share/nginx/html \
  -w=/home/steam \
  -p 60080:80 \
  ${DOCKER_IMG} 


