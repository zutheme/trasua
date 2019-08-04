<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class InsertProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE InsertProductProcedure( IN _namepro VARCHAR(255) CHARSET utf8mb4, IN _description TEXT CHARSET utf8mb4, IN _short_desc TEXT CHARSET utf8mb4, IN _slug VARCHAR(255) CHARSET utf8mb4, IN _id_post_type INT(11), IN _idcustomer INT(11), IN _idemployee INT(11), IN _amount FLOAT(10), IN _price FLOAT(10), IN _note TEXT CHARSET utf8mb4, IN _idstore INT(11), IN _axis_x INT(11), IN _axis_y INT(11), IN _axis_z INT(11), IN _size VARCHAR(10) CHARSET utf8mb4, IN _ice_water FLOAT(10), IN _sugar FLOAT(10), IN _topping VARCHAR(255) CHARSET utf8mb4, IN _status_type INT(11), IN _list_idcat VARCHAR(255) CHARSET utf8mb4, IN _list_file TEXT CHARSET utf8mb4, IN _thumbnail TEXT CHARSET utf8mb4 )
            BEGIN
                DECLARE _idproduct INT;
                INSERT INTO product(name, description, short_desc, slug, id_post_type) VALUES ( _name, _description, _short_desc , _slug, _id_post_type );
                SET _idproduct = LAST_INSERT_ID();
                INSERT INTO imp_products(idproduct, idcustomer, idemployee, amount, price, note, idstore, axis_x, axis_y, axis_z, size, ice_water, sugar, topping, status_type) VALUES ( _idproduct, _idcustomer, _idemployee, _amount, _price, _note, _idstore, _axis_x, _axis_y, _axis_z, _size, _ice_water, _sugar, _topping, _status_type);
                
            END'
        );
    }

    /**
     * Reverse the migrations.
     * INSERT INTO catehasproduct(idproduct,idcategory) VALUES (_idproduct,_idcategory),(4,5,6),(7,8,9);
     * @return void
     */
    public function down()
    {
         DB::unprepared('DROP PROCEDURE IF EXISTS InsertProductProcedure');
    }
}
