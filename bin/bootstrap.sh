#!/bin/bash

echo "export PERSONAL_CONFIGS_DIR=\"$HOME/.personal_configs\"" >> ~/.bashrc
echo "source \"$PERSONAL_CONFIGS_DIR/bash/environ.bash\"" >> ~/.bashrc
echo "source \"$PERSONAL_CONFIGS_DIR/bash/main.bash\"" >> ~/.bashrc

mv ~/.muttrc ~/.muttrc.bk 2> /dev/null
rm ~/.muttrc 2> /dev/null
ln -s $PERSONAL_CONFIGS_DIR/mutt/muttrc ~/.muttrc


mv ~/.msmtprc ~/.msmtprc.bk 2> /dev/null
rm ~/.msmtprc 2> /dev/null
ln -s $PERSONAL_CONFIGS_DIR/mutt/msmtprc ~/.msmtprc
