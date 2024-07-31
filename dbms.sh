#!/bin/bash


while true ;do 
	echo "Main Menue"
	echo "1 Create Data Base" 
	echo "2-List Data Bases"
	echo "3-Connect to Data Base"
	echo "4-Drop Data Base"
	echo "5-Exit"
	read -p "Enter your choice"  choice 


	case $choice in
	    1) create_database ;;
    	    2) list_databases ;;
            3) connect_database ;;
            4) drop_database ;;
            5) exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
    esac
done
