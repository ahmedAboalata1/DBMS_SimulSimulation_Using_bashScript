#!/bin/bash


list_tables(){
	echo "______"
	echo "Tables"
	echo "______"
	ls 
}
create_table(){
 	read -p "Plase Enter Table Name" tb_name
	if [ -f "./$tb_name" ] ; then
		echo "Table $tb_name is already exists "
	else
		touch "./$tb_name.md"
		touch "./$tb_name.dt"
		echo "Table $tb_name Created"
		
}

drop_table(){
        ead -p "Plase Enter Table Name" tb_name
        if [ -f "./$tb_name" ] ; then
               
        else
		echo "Table $tb_name is not exist"

}

select_from_table(){
	read -p "Plase Enter Table Name" tb_name
	if [ -f "./$tb_name" ] ; then
        
        else
		echo "Table $tb_name  is not exists"        

	}

insert_into_table(){
	"Hello From insert"
}
delete_from_table(){
	"Hello From delete"
}
upate_table(){
	"hello From update"
}

