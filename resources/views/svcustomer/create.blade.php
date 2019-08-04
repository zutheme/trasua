@extends('master')
@section('content')
<div class="row">
	<div class="col-sm-6">
		<h2>Thêm mới</h2>
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
		<form method="post" action="{{url('svcustomer')}}">
			{{ csrf_field() }}
			<div class="form-group">
				<input type="text" name="lastname" class="form-control" placeholder="Họ">
			</div>
			<div class="form-group">
				<input type="text" name="firstname" class="form-control" placeholder="Tên">
			</div>
			<div class="form-group">
				<input type="email" name="email" class="form-control" placeholder="Email">
			</div>
			<div class="form-group">
				<input type="text" name="mobile" class="form-control" placeholder="Điện thoại">
			</div>
			<div class="form-group">
				<input type="text" name="address" class="form-control" placeholder="Dịch vụ">
			</div>
			<div class="form-group">
				<input type="text" name="job" class="form-control" placeholder="Nguồn">
			</div>
			<div class="form-group">
				<input type="text" name="note" class="form-control" placeholder="Ghi chú">
			</div>
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
			</div>
		</form>
	</div>
</div>
@stop
