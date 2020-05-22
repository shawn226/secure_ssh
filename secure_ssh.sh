#!/bin/bash


get_passwd(){
	read -p "Voulez-vous un mot de passe ? (y/n) : " answer_pass
	
	if [[ $answer_pass = "y" ]]
	then
		local error=0
		while [[ $error = 0 ]]
		do
			read -s -p "Entrez un mot de passe : " password
			echo ""
			read -s -p "Confirmez le mot de passe : " confirmed_pswd
			echo ""
			
			if [[ $password != $confirmed_pswd ]]
			then
				echo "Erreur les mots de passes ne correspondent pas !"
			else
				error=1
			fi
		done
		echo $password
	fi
}

hashed_mdp=$(get_passwd)


echo "le mot de passe est $hashed_mdp"

# (echo ""; echo ""; echo ""; echo "") | ssh-keygen
