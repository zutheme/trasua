@extends('teamilk.master')

@section('other_styles')

   {{-- <link href="{{ asset('dashboard/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css') }}" rel="stylesheet"> --}}

@stop

@section('content')

@if(isset($error))

{{ $error }}

@endif

{{-- @include('teamilk.shop-banner') --}}

@include('teamilk.grid-3')

@include('teamilk.shop-2-2')

@include('teamilk.shop-1-5')

@include('teamilk.promo-1-2')

{{-- @include('teamilk.shop-4-1') --}}

@include('teamilk.shop-2-7')

{{-- @include('teamilk.shop-3-1') --}}

{{-- @include('teamilk.shop-6-1') --}}

@stop

@section('other_scripts')

   {{-- <script src="{{ asset('assets-tea/custom/order.js?v=0.0.6') }}" type="text/javascript"></script> --}}

@stop