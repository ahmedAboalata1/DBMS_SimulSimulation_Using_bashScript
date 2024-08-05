#!/bin/bash


list_tables(){
	echo "______"
	echo "Tables"
	echo "______"
	ls 
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
        ead -p "Plase Enter Table Name" tb_name
        if [ -f "./$tb_name" ] ; then
               
        else
		echo "Table $tb_name is not exist"
	fi
}

select_from_table(){
	read -p "Plase Enter Table Name" tb_name
	if [ -f "./$tb_name" ] ; then
        
        else
		echo "Table $tb_name  is not exists"        
	fi
	}

insert_into_table(){
	read -p "Please Enter Table Name" tb_name
	if [ ! -f "./$tb_name.md" ] ; then 
		echo "Table $tb_name Does not Exist "
		return 
	fi 
	columns=($(cat "./$tb_name.md"))
	row_vals=()
	
	for col_dif in "${columns[@]}";
	       	col_name=$(echo $col_def | cut -d':' -f1)
		col_type=$(echo $col_def | cut -d':' -f2)

}
delete_from_table(){
	echo "Hello From delete"
}
update_table(){
	echo "hello From update"
}

