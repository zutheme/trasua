<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListCustomerRegisterProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE PROCEDURE ListCustomerRegister(IN _start_date VARCHAR(255),IN _end_date VARCHAR(255), IN _idcategory INT(11), IN _id_post_type INT(11), IN _id_status_type INT(11))
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
        
            SELECT user_reg.idimppost,user_reg.idpost,user_reg.created_at,cus.mobile,cus.firstname,cus.email,user_reg.body,user_reg.address_reg FROM (SELECT imp.created_at,imp.idpost,imp.idimppost,imp.iduser_imp,po.body,imp.address_reg FROM (SELECT im.* FROM (SELECT * FROM impposts WHERE created_at >= _start_date AND  created_at < _end_date) AS im WHERE im.id_status_type=_id_status_type) AS imp JOIN
            (SELECT pt.* FROM (SELECT p.* FROM (SELECT idpost,body,id_post_type,idcategory FROM posts WHERE created_at >= _start_date AND created_at < _end_date) AS p WHERE p.idcategory=_idcategory) AS pt WHERE pt.id_post_type=_id_post_type) AS po ON imp.idpost=po.idpost) AS user_reg JOIN
            sv_customers AS cus ON user_reg.iduser_imp = cus.idcustomer;
            END');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
         DB::unprepared('DROP PROCEDURE IF EXISTS ListCustomerRegisterProcedure');
    }
}
