<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class status_type extends Model
{
    protected $primaryKey = 'id_status_type';
    protected $fillable = ['name_status_type','created_at','updated_at'];
}
