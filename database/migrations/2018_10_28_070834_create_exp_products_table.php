<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateExpProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('exp_products', function (Blueprint $table) {
            $table->increments('idexp');
            $table->bigInteger('idproduct');
            $table->integer('idcustomer')->nullable();
            $table->integer('idemployee')->nullable();
            $table->integer('amount')->nullable();
            $table->integer('price')->nullable();
            $table->integer('note')->nullable();
            $table->integer('idstore')->nullable();
            $table->integer('axis_x')->nullable();
            $table->integer('axis_y')->nullable();
            $table->integer('axis_z')->nullable();
            $table->string('size')->nullable();
            $table->float('ice_water', 8, 2)->nullable();
            $table->float('sugar', 8, 2)->nullable();
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
        Schema::dropIfExists('exp_products');
    }
}
