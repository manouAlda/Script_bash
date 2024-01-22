#!/bin/bash

debian="DEBIAN"
control="Control"
pr_inst="preinst"
po_inst="postinst"
pr_rm="prerm"
po_rm="postrm"

###	Creation du dossier DEBIAN	###

printf "Package = "
read paquet
printf "\n"

if [ -d "$paquet" ]; then
	printf "Ce paquet existe deja , veuillez entrez un autre nom du paquet : "
	read paquet
	mkdir $paquet
else 
	mkdir $paquet
fi
cd $paquet

if [ -d "$debian" ]; then 
	echo "Repertoire DEBIAN"
else 
	mkdir DEBIAN
fi

cd DEBIAN

if [ -e "$control" ]; then
	echo "Control"
else 
	touch $control
fi

printf "\n"

printf "Ecriture dans le fichier control:\n "
printf "********************************\n  "
echo "Package = "$paquet > $control
desk=".desktop"
desktop="${paquet}${desk}"

printf "Version = "
read version
echo "Version = "$version >> $control

printf "Section = "
read section
echo "Section = "$section >> $control

printf "Priority = "
read priori
echo "Priority = "$priori >> $control

printf "Architecture = "
read archi
echo "Architecture = "$archi >> $control

printf "Depends = "
read depends
echo "Depends = "$depends >> $control

printf "Maintainer (nom<nom@email.com>) = "
read maintainer
echo "Maintainer = "$maintainer >> $control

printf "Description = "
read descris
echo "Description = "$descris >> $control

printf "Homepage (adresse du site ) = "
read page
echo "Homepage = "$page >> $control

###	Fichier preinst, postinst, prerm, postrm	###
touch preinst
printf "\nEdition du fichier preinst:\n"
read preinst
echo $preinst > $pr_inst

touch postinst
printf "Edition du fichier postinst:\n"
read postinst
echo $postinst > $po_inst

touch prerm
printf "Edition du fichier prerm:\n"
read prerm
echo $prerm > $pr_rm

touch postrm
printf "Edition du fichier postrm:\n"
read postrm
echo $postrm > $po_rm

printf "\nInterface : application\n"
printf "*************************\n"

cd ..
mkdir -p usr/local/src usr/bin usr/share/applications usr/share/icons usr/share/man/man1
touch usr/share/applications/"$desktop"

cd usr/share/applications

printf "Edition du "$paquet".desktop : \n"
echo "[Desktop Entry]" > desktop
echo "Type=Application" >> desktop
echo "Version="$version >> desktop
echo "Name="$paquet >> desktop

printf "Exec="
read nom_paquet
echo "Exec="$nom_paquet >> desktop

printf "Icon="
read icon
echo "Icon="$icon >> desktop

printf "Terminal="
read terminal
echo "Terminal="$terminal >> desktop

printf "Categoties="
read categ
echo "Categories="$categ";" >> desktop

echo "MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;" >> desktop
echo "StartupNotify=true" >> desktop

cd ../icons
printf "\nInterface : Icons\n"
printf "Entrer le chemin de l'icone : "
read ico
cp $ico .

printf "\nVoulez-vous ajouter une page manuelle? O/N "
read answer

if [ "$answer" = "O" -o "$answer" = "o" ]; then
	cd ../man/man1
	ext=".1"
	ext="${paquet}${ext}"
	touch $ext
	printf "\nEdition de la page manuelle:\n"
	printf "******************************\n"
	read manual
	echo $manual > $ext

fi

### Creation du .deb 	###
#sudo dpkg -b $paquet