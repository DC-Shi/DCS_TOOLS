# cat the content to bash_aliases file

cat <<<'
export DCS_TOOLS="${HOME}/DCS_TOOLS"
if [ -f ${DCS_TOOLS}/bashrc ]; then
  . ${DCS_TOOLS}/bashrc
fi' >> ~/.bash_aliases
