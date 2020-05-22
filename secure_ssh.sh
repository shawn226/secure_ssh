#!/bin/bash


get_passwd(){
	read -p "Voulez-vous un mot de passe ? (n/y) : " answer_pass
	
	if [[ $answer = "y" ]]
	then
		echo $answer
	fi
}

get_passwd

# (echo ""; echo ""; echo ""; echo "") | ssh-keygen
