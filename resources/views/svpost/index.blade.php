@extends('master')

@section('other_styles')
   
@stop

@section('content')
   <div class="row">
	<div class="col-12">
	<div class="card">
	    <div class="card-body">
	        <h4 class="card-title">Thông tin đăng ký</h4>
	        @if($message = Session::get('success'))
	        	<h6 class="card-subtitle">{{ $message }}</h6>
			@endif
			<div align="right">
				<a class="btn btn-default btn-primary" href="{{ route('svpost.create') }}">Thêm mới</a>
			</div>
	        <div class="table-responsive m-t-40">
	            <table id="example23" class="display nowrap table table-hover table-striped table-bordered" cellspacing="0" width="100%">
	                <thead>
	                    <tr>
	                        <th>Chủ đề</th>
							<th>Nội dung</th>
							<th>Đường dẫn</th>
							<th>Loại post</th>
							<th>Chuyên mục</th>
							<th>-</th>
							<th>-</th>
	                    </tr>
	                </thead>
	                <tfoot>
	                    <tr>           
							<th>Chủ đề</th>
							<th>Nội dung</th>
							<th>Đường dẫn</th>
							<th>Loại post</th>
							<th>Chuyên mục</th>
							<th>-</th>
							<th>-</th>
	                    </tr>
	                </tfoot>
	                <tbody>
	                	@foreach($svposts as $row)
							<tr>
								<td>{{ $row['title'] }}</td>
								<td>{{ $row['body'] }}</td>
								<td>{{ $row['url'] }}</td>
								<td>{{ $row['type'] }}</td>
								<td>{{ $row['category'] }}</td>
								<td class="btn-control"><a class="btn btn-primary btn-edit" href="{{ action('SvPostController@edit',$row['id_svpost']) }}"><i class="fa fa-edit"></i></a></td>
								<td class="btn-control">
								   <form method="post" class="delete_form" action="{{action('SvPostController@destroy', $row['id_svpost'])}}">
								      {{csrf_field()}}
								      <input type="hidden" name="_method" value="DELETE" />
								      <button type="submit" class="btn btn-danger btn-delete"><i class="fa fa-trash" aria-hidden="true"></i></button>
								   </form>
								</td>
							</tr>
							@endforeach                
	                </tbody>
	            </table>
	        </div>
	    </div>
	</div>
	</div>
</div>
@stop

@section('other_scripts')
    
@stop