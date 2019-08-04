@extends('master')

@section('other_styles')
   
@stop

@section('content')
   <div class="row">
	<div class="col-12">
	<div class="card">
	    <div class="card-body">
	        <h4 class="card-title">Thông tin nguồn</h4>
	        @if($message = Session::get('success'))
	        	<h6 class="card-subtitle">{{ $message }}</h6>
			@endif
			<div align="right">
				<a class="btn btn-default btn-primary" href="{{ route('svposttype.create') }}">Thêm mới</a>
			</div>
	        <div class="table-responsive m-t-40">
	            <table id="example23" class="display nowrap table table-hover table-striped table-bordered" cellspacing="0" width="100%">
	                <thead>
	                    <tr>
	                        <th>Tên loại</th>
							<th>-</th>
							<th>-</th>
	                    </tr>
	                </thead>
	                <tfoot>
	                    <tr>
	                       <th>Tên loại</th>
	                       <th>-</th>
						   <th>-</th>						
	                    </tr>
	                </tfoot>
	                <tbody>
	                	@foreach($svposttypes as $row)
							<tr>
								<td>{{ $row['name'] }}</td>						
								<td class="btn-control"><a class="btn btn-primary btn-edit" href="{{ action('SvPostTypeController@edit',$row['id_post_type']) }}"><i class="fa fa-edit"></i></a></td>
								<td class="btn-control">
								     <form method="post" class="delete_form" action="{{action('SvPostTypeController@destroy', $row['id_post_type'])}}">
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