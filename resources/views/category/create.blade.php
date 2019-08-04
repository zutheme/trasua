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
		<form class="frm_create_category" method="post" action="{{url('category')}}">
			{{ csrf_field() }}
			<div class="form-group">
				<input type="text" name="name" class="form-control" placeholder="Tên chuyên mục">
			</div>
			{{-- <div class="form-group">
				<input class="idparent" type="hidden" name="idparent" value="">
			</div> --}}
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idparent">Chuyên mục <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idparent" onchange="sel_category('idparent')">
                    	<option value="">Thuộc chuyên mục</option>
                    	@foreach($categories as $row)
                    		 <option value="{{ $row['idcategory'] }}">{{ $row['name'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
			 
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Xác nhận" />
			</div>
		</form>
	</div>
</div>
@stop
@section('other_scripts')
<script>
 //    var e_frm_create_post = document.getElementsByClassName("frm_create_post")[0];
	// var _idparent = e_frm_create_post.getElementsByClassName("idparent")[0].value;
	// var dropdown =  document.getElementsByClassName("cus-drop");
	// var objArray = [];
	
	// for (var i = dropdown.length - 1; i >= 0; i--) {
	//   var d = dropdown[i].addEventListener("change",myFunction);
	// }

	
</script>
@stop