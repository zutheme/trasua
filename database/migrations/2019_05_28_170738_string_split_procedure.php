<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class StringSplitProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE split_string(IN string_split varchar(255), IN _idextend varchar(255), OUT outresult varchar(255))
            BEGIN
                DECLARE x INT;
                DECLARE str_item VARCHAR(255);
                DECLARE item VARCHAR(255);
                DECLARE result VARCHAR(255);
                DECLARE rs_split VARCHAR(255); 
                SET x = LENGTH(string_split);
                set result = "";
                set str_item ="";
                SET item = "";
                set rs_split = string_split;
                WHILE x  > 0 DO
                set item = SUBSTRING_INDEX(rs_split,",", -1);
                set rs_split = SUBSTRING(string_split, 1, (LENGTH(rs_split)-LENGTH(item)-1));
                set str_item = CONCAT("(",_idextend,",", item,")");
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
        DB::unprepared('DROP PROCEDURE IF EXISTS split_string');
    }
}
