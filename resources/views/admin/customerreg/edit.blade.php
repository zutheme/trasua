@extends('admin.dashboard')

@section('other_styles')
      <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.2') }}" rel="stylesheet">
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
		<form class="frm_edit_department" method="post" action="{{action('Admin\DepartmentController@update',$selected[0]['iddepart'])}}">
			{{ csrf_field() }}
			<input type="hidden" name="_method" value="PATCH">
			<div class="form-group">
				<input type="text" name="namedepart" class="form-control" value="{{$selected[0]['namedepart']}}">
			</div>
		
			<div class="form-group row">
                <label class="col-lg-4 col-form-label" for="sel_idparent">Thuộc bộ phận <span class="text-danger">*</span></label>
                <div class="col-lg-8">
                    <select class="form-control cus-drop" name="sel_idparent">
                    	<option value="">Chọn ...</option>
                    	@foreach($departments as $row)
                    		 <option value="{{ $row['iddepart'] }}">{{ $row['namedepart'] }}</option>
						@endforeach        
                    </select>
                </div>
            </div>
            
			<div class="form-group">
				<input type="submit" class="btn btn-default btn-submit" name="btn-submit" value="Cập nhật" />
			</div>
		</form>	
		<script type="text/javascript">
			var selected_idparent = '{{$selected[0]['idparent']}}';
			var name_cat_parent =  '{{$selected[0]['parent']}}';
		</script>
	</div>
</div>

@stop
@section('other_scripts')
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script>
    <script src="{{ asset('dashboard/production/js/edit_department.js?v=0.0.1')}}"></script>   
@stop
