<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateImpProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('imp_products', function (Blueprint $table) {
            $table->increments('idimp');
            $table->bigInteger('idproduct');
            $table->integer('idcustomer')->nullable();
            $table->integer('idemployee')->nullable();
            $table->integer('amount')->nullable();
            $table->decimal('ice_water', 10, 0)->nullable();
            $table->integer('note')->nullable();
            $table->integer('idstore')->nullable();
            $table->integer('axis_x')->nullable();
            $table->integer('axis_y')->nullable();
            $table->string('size')->nullable();
            $table->decimal('ice_water', 10, 0)->nullable();
            $table->decimal('sugar', 10, 0)->nullable();
            $table->string('topping')->nullable();
            $table->timestamp('created_at')->default(\DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(\DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('imp_products');
    }
}
