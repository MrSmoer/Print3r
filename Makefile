NAME=Print3r
VERSION=0.3.2
#DEST_BIN=~/bin/
DEST_BIN=/usr/bin
DEST_SHARE=/usr/share
CMD=print3r
NICK=print3r

all::
	@echo "make requirements install deinstall"

requirements::
	sudo apt install libexpat-dev libcurses-perl libncurses5-dev libreadline-dev
	sudo cpan File::Which IO::Zlib Time::HiRes Device::SerialPort XML::Simple JSON IO::Termios Term::ReadLine::Gnu Linux::Termios2 Algorithm::BinPack::2D 
	sudo apt install libgd-perl ser2net socat slic3r
	sudo apt install yagv

install::
	sudo cp ${CMD} ${DEST_BIN}/
	mkdir -p ${HOME}/.config/${NICK}; cd ${HOME}/.config/${NICK}; mkdir -p printer macro macro/filament slicer gconsole gconsole/commands 
	sudo mkdir -p ${DEST_SHARE}/${NICK}
	cd settings; tar cf - printer/*.ini macro/*.ini macro/filament/*.ini slicer/*.json slicer/*/base.ini slicer/*/map.ini slicer/*/*.def.json gconsole | (cd ${DEST_SHARE}/${NICK}/; sudo tar xf -)

deinstall::
	sudo rm -f ${DEST_BIN}/${CMD}

# ---------------------------------------------------------------------------------------------------------------
# -- developer(s) only:

edit::
	dee4 print3r Makefile README.md LICENSE settings/slicer/*.json settings/*/*.ini settings/gconsole/commands/*

backup::
	cd ..; tar cfz ${NAME}-${VERSION}.tar.gz "--exclude=*/slicers/*" ${NAME}; mv ${NAME}-${VERSION}.tar.gz ~/Backup; scp ~/Backup/${NAME}-${VERSION}.tar.gz backup:Backup/

backup-settings::
	cd ~/; tar cfz ${NAME}-Config-`date +%F`.tar.gz .config/print3r; mv ${NAME}-Config-`date +%F`.tar.gz ~/Backup/; scp ~/Backup/${NAME}-Config-`date +%F`.tar.gz backup:Backup/

change::
	git commit -am "..."

pull::
	git pull

push::
	git push -u origin master

examples::
	./print3r --fill-density=0 --output=examples/cube.png render Parts/cube.scad
	./print3r --fill-density=0 --scale=50mm --output=examples/cube-scaled1.png render Parts/cube.scad
	./print3r --fill-density=0 --scale=10mm,20mm,100mm --output=examples/cube-scaled2.png render Parts/cube.scad
	./print3r --fill-density=0 --output=examples/benchy.png render Parts/3DBenchy.stl
	./print3r --fill-density=0 --scale=0,0,150mm --output=examples/benchy-scaled.png render Parts/3DBenchy.stl

