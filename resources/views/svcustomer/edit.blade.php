@extends('master')

@section('other_styles')
    
@stop
@section('content')
<div class="row">
	<div class="col-sm-6">
		<h2>Chỉnh sửa</h2>
		@if(count($errors) > 0)
		<div class="alert alert-danger">
			<ul>
				@foreach($errors->all() as $error)
					<li>{{ $error }}</li>
				@endforeach
			</ul>
		</div>
		@endif
		@if(\Session::has('success'))
			<div class="alert alert-success">
				<p>{{ \Session::get('success') }}</p>
			</div>
		@endif
		<form method="post" action="{{action('SvCustomerController@update',$idcustomer)}}">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			<div class="form-group">
				<input type="text" name="firstname" class="form-control" value="{{$svcustomer->firstname}}">
			</div>
			<div class="form-group">
				<input type="text" name="lastname" class="form-control" value="{{ $svcustomer->lastname}}">
			</div>
			<div class="form-group">
				<input type="email" name="email" class="form-control" value="{{ $svcustomer->email}}">
			</div>
			<div class="form-group">
				<input type="text" name="mobile" class="form-control" value="{{ $svcustomer->mobile}}">
			</div>
			<div class="form-group">
				<input type="text" name="address" class="form-control" value="{{$svcustomer->address}}">
			</div>
			<div class="form-group">
				<input type="text" name="job" class="form-control" value="{{$svcustomer->job}}">
			</div>
			<div class="form-group">
				<input type="text" name="note" class="form-control" value="{{$svcustomer->note}}">
			</div>
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Cập nhật" />
			</div>
		</form>
	</div>
</div>
@stop

@section('other_scripts')
     <script src="{{ asset('public/js/customer.js?v=0.8.9') }}"></script> 
@stop