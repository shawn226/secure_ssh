#!/bin/bash


get_passwd(){
	read -p "Voulez-vous un mot de passe ? (y/n) : " answer_pass
	
	if [[ $answer_pass = "y" ]]
	then
		local error=0
		while [[ $error = 0 ]]
		do
			read -p "Entrez un mot de passe : " password
			read -p "Confirmez le mot de passe : " confirmed_pswd
			
			if [[ $password != $confirmed_pswd ]]
			then
				echo "Erreur les mots de passes ne correspondent pas !"
			else
				error=1
		done	
	fi
}

get_passwd

# (echo ""; echo ""; echo ""; echo "") | ssh-keygen
