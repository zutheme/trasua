<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListViewProductByIdCateProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("CREATE PROCEDURE ListViewProductByIdCateProcedure(IN _idcategory INT(11), IN _id_post_type INT(11), IN _id_status_type INT(11), IN _limit INT(11))
        BEGIN
            select allpro.* from (SELECT alp.*,imp.price,imp.price_sale_origin from (select pro.*,(select urlfile from files WHERE idfile = pro.idfile) as url from (select chp.idproduct,p.namepro,p.slug,p.short_desc,p.description,p.idsize,p.idcolor,(select idfile from producthasfile where hastype = 'thumbnail' and idproduct = chp.idproduct ORDER BY idproducthasfile DESC LIMIT 1) as idfile from (SELECT * FROM catehasproduct WHERE idcategory=_idcategory) as chp JOIN products as p on chp.idproduct = p.idproduct) as pro) as alp JOIN (SELECT * from imp_products where idstore=31) as imp on alp.idproduct = imp.idproduct) as allpro order by allpro.idproduct DESC limit _limit;
        END");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS ListViewProductByIdCateProcedure');
    }
}
