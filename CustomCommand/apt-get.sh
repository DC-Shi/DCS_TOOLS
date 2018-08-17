# Require DCS_TOOLS for functioning.

if [ -z "${DCS_TOOLS}" ]
then
  echo Cannot find var: DCS_TOOLS !
  echo Please run sudo visudo to add following line:
  echo Defaults env_keep += "DCS_TOOLS"
else
  # Get current date, write the logs to 
  CUS_LOG=${DCS_TOOLS}/Logs
  mkdir -p ${CUS_LOG}
  
  /usr/bin/apt-get "$@"
  # Analyze return value
  RET=$?
  if [ $RET -eq 0 ];then
    echo $(date --iso-8601=seconds)	success	apt-get "$@" >> ${CUS_LOG}/installed.software
  else
    echo $(date --iso-8601=seconds)	FAILED.	apt-get "$@" >> ${CUS_LOG}/installed.software
    echo Error in apt-get: $RET
    exit $RET
  fi

fi
