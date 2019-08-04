<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class imp_product extends Model
{
     protected $primaryKey = 'idimp';
     protected $fillable = ['idproduct','idcustomer','idemp','amount','price','note','idagency','idtypeimp','created_at','updated_at'];
}
