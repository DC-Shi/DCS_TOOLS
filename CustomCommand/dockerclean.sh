#!/bin/bash

# Step 1: if tmpfile not exist, save exited docker containers to tmp file
# Step 2: show container details
# Step 3: If confirmed, remove the container.

TMPCONTAINERLIST=tmp.container.list

# Step 1
if [ ! -f "$TMPCONTAINERLIST" ]
then
  echo "Creating list file $TMPCONTAINERLIST for exited container"
  docker ps -a -f status=exited >> $TMPCONTAINERLIST
fi

# Step 2
#awk '{print $1}' $TMPCONTAINERLIST
cat $TMPCONTAINERLIST

read -p "Are you sure to remove containers? (Upper Y to confirm) " -n 1 -r
echo ""   # (optional) move to a new line
# Step 3
if [[ $REPLY =~ ^[Y]$ ]]
then
  # do dangerous stuff
  while read line; do
    docker rm $(echo "$line" | awk '{print $1}')
  done <$TMPCONTAINERLIST

  rm $TMPCONTAINERLIST
else
  echo "Check $TMPCONTAINERLIST for more details."
fi


