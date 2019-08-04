<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class InsertFilePath extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE InsertFilePath(IN _str_list_file varchar(255), OUT outresult varchar(255))
            BEGIN
                
                SET @s = CONCAT("INSERT INTO files(urlfile,name_origin,namefile, typefile) VALUES ", _str_list_file); 
                    PREPARE stmt1 FROM @s; 
                    EXECUTE stmt1; 
                    DEALLOCATE PREPARE stmt1;
                set outresult = LAST_INSERT_ID();             
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
        DB::unprepared('DROP PROCEDURE IF EXISTS InsertFilePath');
    }
}
