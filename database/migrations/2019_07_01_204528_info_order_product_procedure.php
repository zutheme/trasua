<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class InfoOrderProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE InfoOrderProductProcedure(IN _ordernumber int(11))
            BEGIN
                select inf.*, (inf.price_top+inf.price_parent) as unit_price, ((inf.price_top+inf.price_parent)*inf.amount_panent) as mountxprice from (select GROUP_CONCAT(info_order.l_topping SEPARATOR " ") as ltopping, sum(info_order.price) as price_top, info_order.parentidproduct, info_order.namepro, info_order.amount_panent,info_order.price_parent, info_order.urlparent, info_order.created_at from (select CONCAT("<li><lable>",info.topping,"</label> ",info.price,"<span class=\"vnd\"></span></li>") as l_topping,info.idproduct, info.parentidproduct, info.price, info.namepro, price_parent, info.amount_panent,info.urlparent, info.created_at from (select cte1.namepro as topping, cte1.idproduct,cte1.parentidproduct, cte1.amount, cte1.price, cte1.urlfile ,cte2.namepro,cte2.price as price_parent,cte2.amount as amount_panent,cte2.urlfile as urlparent, cte2.created_at from (select  ordpro.namepro,ordpro.idproduct,parentidproduct,ordpro.amount,ordpro.price,(select urlfile from files where idfile = ordpro.idfile) as urlfile from (select p.namepro,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber =  _ordernumber) as ex join products as p on ex.idproduct = p.idproduct) as ordpro) as cte1 JOIN (select  ordpro.namepro,ordpro.idproduct,parentidproduct,ordpro.amount,ordpro.price,(select urlfile from files where idfile = ordpro.idfile) as urlfile, ordpro.created_at from (select p.namepro,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber =  _ordernumber and parentidproduct = 0) as ex join products as p on ex.idproduct = p.idproduct) as ordpro) as cte2 on cte1.parentidproduct = cte2.idproduct) as info) as info_order GROUP BY info_order.parentidproduct) as inf;    
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
        DB::unprepared('DROP PROCEDURE IF EXISTS InfoOrderProductProcedure');
    }
}
