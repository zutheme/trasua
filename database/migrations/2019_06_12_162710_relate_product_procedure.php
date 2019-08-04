<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class RelateProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE RelateProductProcedure(IN _start_date VARCHAR(255),IN _end_date VARCHAR(255), IN _idcategory INT(11), IN _id_post_type INT(11), IN _id_status_type INT(11))
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
                select info.created_at,info.idproduct,info.namepro,info.short_desc, info.price,info.amount,info.urlfile from (select dtail.created_at,dtail.idproduct,dtail.namepro,dtail.short_desc, dtail.price,dtail.amount,dtail.urlfile,dtail.author, (select namecat from categories WHERE idcategory = prohas.idcategory) as namecat from ( select detail.created_at,detail.idproduct,detail.namepro,detail.short_desc, detail.price,detail.amount,f.urlfile,(select `name` from users WHERE id = detail.iduser) as author from (select p.created_at,p.idproduct,p.namepro,p.short_desc, imp.price,imp.amount,imp.iduser,(select idfile from producthasfile WHERE idproduct = p.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile  FROM products as p JOIN imp_products as imp on p.idproduct = imp.idproduct) as detail join files as f on detail.idfile = f.idfile) as dtail JOIN (select * from catehasproduct where idcategory > 0) as prohas on prohas.idproduct = dtail.idproduct) as info limit 8; 
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
        DB::unprepared('DROP PROCEDURE IF EXISTS RelateProductProcedure');
    }
}
