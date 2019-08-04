<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class exp_product extends Model
{
    protected $primaryKey = 'idexp';
    protected $fillable = ['idproduct','idcustomer','idemp','amount','price','note','idagency','idtypeimp','created_at','updated_at'];
}
