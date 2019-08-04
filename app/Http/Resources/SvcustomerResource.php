<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class SvcustomerResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return parent::toArray($request);
      //   return [
      //   'idcustomer' => $this->idcustomer,
      //   'firstname' => $this->firstname,
      //   'lastname' => $this->lastname,
      //   'email' => $this->email,
      //   'mobile' => $this->mobile,
      //   'address' => $this->address,
      //   'job' => $this->job,
      //   'created_at' => (string) $this->created_at,
      //   'updated_at' => (string) $this->updated_at,
      // ];
    }
}
