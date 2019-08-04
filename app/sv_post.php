<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class sv_post extends Model
{
    protected $primaryKey = 'id_svpost';
    protected $fillable = ['title','body','url','id_post_type','idcategory','created_at','updated_at'];
}
