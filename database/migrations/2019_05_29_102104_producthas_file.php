<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ProducthasFile extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ProducthasFile(IN _list_file varchar(255), IN _sign varchar(10), IN _str_extend varchar(255), OUT outresult varchar(255))
            BEGIN
                DECLARE x INT;
                DECLARE str_item VARCHAR(255);
                DECLARE item VARCHAR(255);
                DECLARE result VARCHAR(255);
                DECLARE rs_split VARCHAR(255); 
                SET x = LENGTH(_list_file);
                set result = "";
                set str_item ="";
                SET item = "";
                set rs_split = _list_file;
                WHILE x  > 0 DO
                set item = SUBSTRING_INDEX(rs_split, _sign, -1);
                set rs_split = SUBSTRING(_list_file, 1, (LENGTH(rs_split)-LENGTH(item)-1));
                set str_item = CONCAT("(",str_extend,",", item,")");
                set result = CONCAT(result,",", str_item);
                set x = LENGTH(rs_split);
                END WHILE;
                set outresult = SUBSTRING(result,2); 
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ProducthasFile');
    }
}
