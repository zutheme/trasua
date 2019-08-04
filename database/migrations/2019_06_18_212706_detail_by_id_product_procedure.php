<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class DetailByIdProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE DetailByIdProductProcedure(IN _idproduct INT(11))
            BEGIN
                 DECLARE id_thumbnail int;
                                declare url_thumbnail varchar(255);
                                set id_thumbnail =  (SELECT idfile from producthasfile WHERE idproduct=_idproduct and hastype="thumbnail" ORDER BY idproducthasfile DESC LIMIT 1);
                                set url_thumbnail = (SELECT urlfile FROM files where idfile = id_thumbnail);
                                select p.namepro,p.slug,p.short_desc,p.description,p.idsize,p.idcolor,p.id_post_type,p.created_at as created_pro,p.updated_at as updated_pro,imp.*,id_thumbnail, url_thumbnail from (select * FROM products WHERE idproduct=_idproduct) as p join (SELECT * from imp_products where idproduct=_idproduct ORDER BY idimp DESC LIMIT 1) as imp on p.idproduct = imp.idproduct;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS DetailByIdProductProcedure');
    }
}
