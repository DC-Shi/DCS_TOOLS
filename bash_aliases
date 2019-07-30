# cat the content to bash_aliases file

if [[ -z "${DCS_TOOLS}" ]]
then
  cat <<<'
  export DCS_TOOLS="${HOME}/DCS_TOOLS"
  if [ -f ${DCS_TOOLS}/bashrc ]; then
    . ${DCS_TOOLS}/bashrc
  fi' >> ~/.bash_aliases
else
  echo "Already installed, do nothing"
fi
