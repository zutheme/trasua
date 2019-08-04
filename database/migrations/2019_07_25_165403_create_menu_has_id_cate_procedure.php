<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMenuHasIdCateProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE CreateMenuHasIdCateProcedure(IN _str_query varchar(255))
            BEGIN
                SET @sqlv=_str_query;
                PREPARE stmt FROM @sqlv;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;  
            END"
        );
    }

    /**
     * Reverse the migrations.
     * How to use:
     * SET @sql = CONCAT('SELECT * FROM Fruits WHERE Name IN (', fruitArray, ')');
     * SET @fruitArray = '\'apple\',\'banana\'';
     * CALL GetFruits(@fruitArray);
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS CreateMenuHasIdCateProcedure');
    }
}
