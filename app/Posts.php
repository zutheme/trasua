<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Posts extends Model
{
    protected $primaryKey = 'idpost';
    protected $fillable = ['title','body','slug','idcategory','id_post_type','created_at','updated_at'];
}
