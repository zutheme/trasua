<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE PROCEDURE ListProductProcedure(IN _start_date VARCHAR(255),IN _end_date VARCHAR(255), IN _idcategory INT(11), IN _id_post_type INT(11), IN _id_status_type INT(11))
        BEGIN
        DECLARE _now VARCHAR(255);
        DECLARE _str_start VARCHAR(255);
        DECLARE _now_time VARCHAR(255);
        SET _now_time = NOW();
        IF ( _start_date IS NULL OR _start_date ="") THEN
        BEGIN
            SET _now = DATE(_now_time);
            SET _str_start = CONCAT(_now," 00:00:00");
            SET _start_date = STR_TO_DATE(_str_start,"%Y-%m-%d %H:%i:%s");          
        END;
        END IF;
        IF ( _end_date IS NULL OR _end_date = "") THEN SET _end_date = _now_time;       
        END IF;  
            SELECT * from products;
            END');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
