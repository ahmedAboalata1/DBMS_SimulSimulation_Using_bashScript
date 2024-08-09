#!/bin/bash

LOG_FILE="/home/$USER/tableErrors.log"


list_tables(){
	echo "______"
	echo "Tables"
	echo "______"
	ls *.dt 2>>$LOG_FILE || echo  "No Tables Found" 
}

create_table()
{
       	read -p "Plase Enter Table Name" tb_name
        if [ -f "./$tb_name" ] ; then
                echo "Table $tb_name is already exists "
        else
                touch "./$tb_name.md"
                touch "./$tb_name.dt"
                echo "Table $tb_name Created"
		read -p "Plaese Enter Number Of Columns " num_cols
		count=1
		while [ $count -le $num_cols ] ; do
			read -p "Enter Col name " col_name
			while true ; do
				read -p "Enter Data Type of $col_name Column (1 for int, 2 for string):  " col_type 
				case $col_type in
					1) col_type="int"; break ;;
					2) col_type="string"; break ;;
					*) echo "Invalid data type. Please enter '1' for int or '2' for string." ;;
				esac
			done
			echo "$col_name:$col_type" >> "./$tb_name.md"
			count=$((count+1))
		done 
		echo "Table $tb_name created successfully"
	fi
}

drop_table(){
        read -p "Plase Enter Table Name" tb_name
        if [ -f "./$tb_name.dt" ] ; then
		read -p "Are you sure you want to drop $table_name? (y/n): " confirm
	    	case "$confirm" in
		    	y|Y)
				rm "$table_name.dt"
				rm "$table_name.md"
				echo "Table $table_name Dropped Successfully"
				;;
		    	n|N)
				echo "Dropping cancelled"
				;;
		    	*)
				echo "Unknown option"
				;;
		esac
      	else
	    	echo "Table $table_name does not exist."
      	fi

        }

select_from_table(){
	echo "hello From select"
}

insert_into_table(){
	read -p "Plase Enter Table Name" tb_name
        metadata_file="./$tb_name.md"
        data_file="./$tb_name.dt"
        if [ -f "./$metadata_file" ] ; then
                columns=$(cut -d: -f1 "$metadata_file")
                data_types=$(cut -d: -f2 "$metadata_file")

                IFS=$'\n' read -r -d '' -a column_array <<< "$columns"
                IFS=$'\n' read -r -d '' -a data_type_array <<< "$data_types"
                values=""
                for i in "${!column_array[@]}"; do
                        column="${column_array[$i]}"
                        data_type="${data_type_array[$i]}"
                        while true ; do
                                read -p "Enter value for $column ($data_type): " value
                                if [[ "$data_type" == "int" && ! "$value" =~ ^-?[0-9]+$ ]]; then
                                        echo "Invalid input. Please enter an integer for $column."
                                elif [[ "$data_type" == "string" && "$value" =~ [^[:alnum:][:space:]] ]]; then
                                        echo "Invalid input. Please enter a string for $column."
                                else
                                        break
                                fi
                        done
                        values="$values$value,"
                        echo "${values%,}" >> "$data_file"
                       
                done
		echo "Row inserted into $table_name ."
        else
                echo "Table $tb_name  is not exists"
        fi
}
delete_from_table(){
	echo "Hello From delete"
}
update_table(){
	echo "hello From update"
}

