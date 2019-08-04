<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class category extends Model
{
    protected $primaryKey = 'idcategory';
    protected $fillable = ['namecat','idcattype','idparent','created_at','updated_at'];
}
