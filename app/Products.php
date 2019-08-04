<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    protected $primaryKey = 'idproduct';
    protected $fillable = ['namepro','slug','short_desc','description','idsize','idcolor','id_post_type','created_at','updated_at'];
}
