# afh
AFH: Ad Free Home. Drop in place ad blocker using bind. 

Note: This does not do any destructive measures on existing files. This is meant to be an 'addon' to existing bind servers, however this will work as an initial installation.

1) Run install.sh<br />
2) Point your DNS resolvers for any computers in your network to the IP of the computer you ran install.sh on<br />
3) Enjoy!<br />

This script implements a crontab referencing wherever the install.sh directory is at (ie. it runs pwd.) That means, if you're downloading it but don't want it somewhere that could be deleted, like /home/youruser/Downloads, _PLEASE_ move it to /opt or somewhere and execute install.sh from there.
