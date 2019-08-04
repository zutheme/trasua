<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class exppost extends Model
{
    protected $primaryKey = 'idexppost';
    protected $fillable = ['idpost','idcategory','id_post_type','status_type','iduser_exp','created_at','updated_at'];
}
