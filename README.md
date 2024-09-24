These are just my crappy shell scripts. you can install them if you want.

## INSTALL
you can install the scripts you want with the make command. there are a couple of steps you will have to take to make sure it installs properly

create config.mk
```
make config
```

edit this file by adding a 1 next any scripts you want to install in the config.mk. 0 means it will not install that script

install
```
sudo make install
```
by default it will save to /usr/local/bin/ unless you override the $PREFIX variable
