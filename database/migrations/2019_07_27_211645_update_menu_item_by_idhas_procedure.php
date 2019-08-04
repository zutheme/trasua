<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateMenuItemByIdhasProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE UpdateMenuItemByIdhasProcedure(IN _str_query varchar(255))
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
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS UpdateMenuItemByIdhasProcedure');
    }
}
