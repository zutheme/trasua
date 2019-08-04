<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CategoryHasProduct extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE CategoryHasProduct(IN _list_idcat varchar(255), IN _idproduct int(11))
            BEGIN
                declare list_idcat varchar(255);
                set @_sign = ",";
                call split_string(_list_idcat, _idproduct, @_sign, list_idcat); 
                SET @s = CONCAT("INSERT INTO catehasproduct (idproduct,idcategory) VALUES ", list_idcat); 
                PREPARE stmt1 FROM @s; 
                EXECUTE stmt1; 
                DEALLOCATE PREPARE stmt1;             
            END'
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS CategoryHasProduct');
    }
}
