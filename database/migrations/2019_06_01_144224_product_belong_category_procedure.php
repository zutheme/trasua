<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ProductBelongCategoryProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ProductBelongCategoryProcedure(IN _list_idcat text CHARSET utf8mb4)
            BEGIN
                SET @s = CONCAT("INSERT INTO catehasproduct (idproduct,idcategory) VALUES ", _list_idcat); 
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ProductBelongCategoryProcedure');
    }
}
