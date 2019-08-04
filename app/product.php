<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class product extends Model
{
     protected $primaryKey = 'idproduct';
     protected $fillable = ['name','short_desc','discription','idsize','idcolor','idtypeproduct','idcategory','created_at','updated_at'];
}
