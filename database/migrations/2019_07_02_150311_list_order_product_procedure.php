<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListOrderProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
         DB::unprepared("
            CREATE PROCEDURE ListOrderProductProcedure(IN _start_date VARCHAR(255), IN _end_date VARCHAR(255), IN _idstore INT(11), IN _id_post_type INT(11), IN _id_status_type INT(11), IN _sel_receive INT(11))
            BEGIN
               select exp.ordernumber, exp.created_at, case when (exp.iduser > 0) THEN (select CONCAT_WS(', ',CONCAT_WS(' ',p.lastname, p.middlename, p.firstname),CONCAT_WS(' ',p.address, (select namedist from district where iddistrict = p.iddistrict), (select namecitytown from city_town where idcitytown = p.idcitytown)),p.mobile) from `profile` as p where iduser = exp.iduser) when (exp.idcustomer > 0) THEN  (select CONCAT_WS(',',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idcustomer) END as customer, case when (exp.idrecipent > 0) THEN  (select CONCAT_WS(',',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idrecipent)
                    when (exp.idcustomer > 0) THEN  (select CONCAT_WS(',',CONCAT_WS(' ',cus.lastname,cus.middlename,cus.firstname),CONCAT_WS(', ',cus.address, (select namedist from district where iddistrict = cus.iddistrict), (select namecitytown from city_town where idcitytown = cus.idcitytown)),cus.mobile) from sv_customers as cus WHERE idcustomer = exp.idcustomer) 
                    ELSE (select CONCAT_WS(', ',CONCAT_WS(' ',p.lastname, p.middlename, p.firstname),CONCAT_WS(' ',p.address, (select namedist from district where iddistrict = p.iddistrict), (select namecitytown from city_town where idcitytown = p.idcitytown)),p.mobile) from `profile` as p where iduser = exp.iduser) END as recipent, 
                    exp.iduser, exp.idcustomer, exp.idrecipent,exp.itemtotal from (select ex.ordernumber, sum((ex.amount*ex.price)) as itemtotal, ex.created_at, ex.idrecipent, ex.idcustomer, ex.iduser 
                    from (select * from exp_products where idstore='11') as ex GROUP BY ordernumber) as exp;  
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListOrderProductProcedure');
    }
}
