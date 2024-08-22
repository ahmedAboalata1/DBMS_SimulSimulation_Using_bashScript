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
	    read -p "Enter the name of the table to select from: " table_name
	    metadata_file="./$table_name.md"
	    data_file="./$table_name.dt"
	    if [ ! -f "$metadata_file" ] || [ ! -f "$data_file" ]; then
	    	    echo "Table $table_name does not exist."
	    	    return
	    fi
	    columns=$(cut -d: -f1 "$metadata_file")
	    IFS=$'\n' read -r -d '' -a column_array <<< "$columns"
	    echo "Available columns: ${column_array[*]}"

	    read -p "Enter the column name to search by: " search_column
	    if ! grep -q "^$search_column:" "$metadata_file"; then
	    	    echo "Column $search_column does not exist."
	    	    return
	    fi
	 
	    read -p "Enter the value to search for in $search_column ( * to select all):  " search_value

	    col_index=$(grep -n "^$search_column:" "$metadata_file" | cut -d: -f1)
	    echo "Results:"
	    echo "========"
	    echo "${column_array[*]}" 
	    while IFS=',' read -r -a row; do
	    if [[ "$search_value" == "*" ]] || [[ "${row[$((col_index-1))]}" == "$search_value" ]]; then
	    	    echo "${row[*]}"
	    fi
    done < "$data_file"
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
                done
		echo "${values%,}" >> "$data_file"
		echo "Row inserted into $table_name ."
        else
                echo "Table $tb_name  is not exists"
        fi
}
delete_from_table(){
    	read -p "Enter the name of the table to delete from: " table_name
	metadata_file="./$table_name.md"
    	data_file="./$table_name.dt"
    
    	if [ ! -f "$metadata_file" ] || [ ! -f "$data_file" ]; then
		echo "Table $table_name does not exist."
		return
    	fi

	columns=$(cut -d: -f1 "$metadata_file")
    	IFS=$'\n' read -r -d '' -a column_array <<< "$columns"
    	echo "Available columns: ${column_array[*]}"
    	read -p "Enter the column name to search by: " search_column
      	if ! grep -q "^$search_column:" "$metadata_file"; then
	      	echo "Column $search_column does not exist."
		return
    	fi

    	read -p "Enter the value to delete for in $search_column: " search_value
    	col_index=$(grep -n "^$search_column:" "$metadata_file" | cut -d: -f1)
    	# Create a temporary file to store the filtered data

      	temp_file="./temp_$table_name.dt"
	# # Initialize a flag to track if any row was deleted
       
       	row_deleted=false
    	# Read through the data file and copy all lines that do not match the search value to the temp file
	 while IFS=',' read -r -a row; do
		 if [[ "${row[$((col_index-1))]}" != "$search_value" ]]; then
	     		 echo "${row[*]}" >> "$temp_file"
		      	 row_deleted=true
	 	 fi
	 done < "$data_file"

	    # Check if any row was deleted
 
	    if $row_deleted; then
		    mv "$temp_file" "$data_file"
		    echo "Rows matching $search_value in $search_column have been deleted from $table_name."
	    else
	    	    echo "No matching rows found for $search_value in $search_column."
	    	    rm "$temp_file"
	    fi

}
update_table(){
       	read -p "Enter the name of the table to update: " table_name
    	metadata_file="./$table_name.md"
    	data_file="./$table_name.dt"
    
    	if [ ! -f "$metadata_file" ] || [ ! -f "$data_file" ]; then
		echo "Table $table_name does not exist."
		return
    	fi

    # Get column names
   
        columns=$(cut -d: -f1 "$metadata_file")
    	IFS=$'\n' read -r -d '' -a column_array <<< "$columns"
    	echo "Available columns: ${column_array[*]}"

    # Prompt for the column to search by
        read -p "Enter the column name to search by: " search_column
    	if ! grep -q "^$search_column:" "$metadata_file"; then
		echo "Column $search_column does not exist."
		return
    	fi

    # Prompt for the value to match
         read -p "Enter the value to search for in $search_column: " search_value

    # Determine the index of the search column
        col_index=$(grep -n "^$search_column:" "$metadata_file" | cut -d: -f1)

    # Prompt for the column to update
        read -p "Enter the column name to update: " update_column
    	if ! grep -q "^$update_column:" "$metadata_file"; then
		echo "Column $update_column does not exist."
		return
    	fi

    # Determine the index of the update column
        update_col_index=$(grep -n "^$update_column:" "$metadata_file" | cut -d: -f1)

    # Prompt for the new value
        read -p "Enter the new value for $update_column: " new_value

    # Create a temporary file to store the updated data
        temp_file="./temp_$table_name.dt"

    # Initialize a flag to track if any row was updated
        row_updated=false

    # Read through the data file and update the rows that match the search value
        while IFS=',' read -r -a row; do
	    	if [[ "${row[$((col_index-1))]}" == "$search_value" ]]; then
	    		row[$((update_col_index-1))]="$new_value"
	    		row_updated=true
		fi
	   	echo "${row[*]}" >> "$temp_file"
    	done < "$data_file"

    # Check if any row was updated
        if $row_updated; then
		mv "$temp_file" "$data_file"
		echo "Rows matching $search_value in $search_column have been updated."
    	else
		echo "No matching rows found for $search_value in $search_column."
		rm "$temp_file"
    	fi
}

