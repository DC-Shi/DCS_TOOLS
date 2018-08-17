# echo with DEBUG set
debugecho()
{
if [[ ! -z "$DEBUG" ]]; then
  echo "$@"
fi
}

# For colored text
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check whether we specify folder to check.
if [ "$1" = "--help" ]
then
  echo "Usage: $0 [folder_path]"
  echo Check all the cert.pem file, and show expired or not.
  exit 0
elif [ -z "$1" ]
then
  # No parameter present, so use current directory.
  CERT_FOLDER=$(dirname $0)
else
  CERT_FOLDER=$1
fi

debugecho "cert folder is: ${CERT_FOLDER}"

# Check each cert in folder
for cert in ${CERT_FOLDER}/*.cert.pem ;
do
  debugecho "${cert}"
  # skip if cert file is false
  [ -f "$cert" ] || continue

  # View certiface infos
  # https://stackoverflow.com/questions/9758238/how-to-view-the-contents-of-a-pem-certificate/35362447#35362447
  # Replace strings
  # https://stackoverflow.com/questions/3306007/replace-a-string-in-shell-script-using-a-variable
  ExpireInfo=$(openssl x509 -in "${cert}" -text | grep After)
  ExpireDate=$(echo $ExpireInfo | sed -e "s/Not After ://g")
  debugecho $ExpireDate

  # Get date to compare
  # https://unix.stackexchange.com/questions/24626/quickly-calculate-date-differences
  dexpire=$(date -d "$ExpireDate" +%s)
  dnow=$(date  +%s)

  # expire date is more than today, then it should be valid.
  if [[ dexpire -gt dnow ]]; then
    printf "${GREEN}${cert}${NC} will expire on $ExpireDate\n"
  else
    printf "${RED}${cert}${NC} expired on $ExpireDate\n"
  fi

done
