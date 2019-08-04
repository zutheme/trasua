<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    protected $primaryKey = 'iddepart';
    protected $fillable = ['namedepart','idparent','created_at','updated_at'];
}
