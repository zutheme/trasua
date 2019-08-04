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
				<a class="btn btn-default btn-primary" href="{{ route('svcustomer.create') }}">Thêm mới</a>
			</div>
	        <div class="table-responsive m-t-40">
	            <table id="example23" class="display nowrap table table-hover table-striped table-bordered" cellspacing="0" width="100%">
	                <thead>
	                    <tr>
	                        <th>Họ</th>
							<th>Tên</th>
							<th>Email</th>
							<th>Điện thoại</th>
							<th>Dịch vụ</th>
							<th>Nguồn</th>
							<th>Ghi chú</th>
							<th>-</th>
							<th>-</th>
							<th>-</th>
	                    </tr>
	                </thead>
	                <tfoot>
	                    <tr>
	                       <th>Họ</th>
							<th>Tên</th>
							<th>Email</th>
							<th>Điện thoại</th>
							<th>Dịch vụ</th>
							<th>Nguồn</th>
							<th>Ghi chú</th>
							<th></th>
							<th></th>
							<th></th>
	                    </tr>
	                </tfoot>
	                <tbody>
	                	@foreach($svcustomers as $row)
							<tr>
								<td>{{ $row['lastname'] }}</td>
								<td>{{ $row['firstname'] }}</td>
								<td>{{ $row['email'] }}</td>
								<td>{{ $row['mobile'] }}</td>
								<td>{{ $row['address'] }}</td>
								<td>{{ $row['job'] }}</td>
								<td>{{ $row['note'] }}</td>
								<td class="btn-control-action">
								    <a class="btn btn-primary btn-action" href="javascript:void(0)"><i class="fa fa-comments-o"></i></a>
								 </td>
								<td class="btn-control"><a class="btn btn-primary btn-edit" href="{{ action('SvCustomerController@edit',$row['idcustomer']) }}"><i class="fa fa-edit"></i></a></td>
								<td class="btn-control">
								     <form method="post" class="delete_form" action="{{action('SvCustomerController@destroy', $row['idcustomer'])}}">
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

  <div class="modal-cus">
    <div class="modal-content-cus">
      <span class="close">&times;</span>
      	 <div class="card">
            <div class="card-body">
                <div class="form-validation">
                    <form class="form-valide frm_post">
						<div class="form-group row">
                            <label class="col-lg-2 col-form-label" for="val-username">Tiêu đề <span class="text-danger"></span></label>
                            <div class="col-lg-10">
                                <input type="text" class="form-control title" name="title" placeholder="Tiêu đề">
                            </div>
                        </div>
						<div class="form-group row">
                            <label class="col-lg-2 col-form-label" for="val-username">Nội dung <span class="text-danger"></span></label>
                            <div class="col-lg-10">
                               <textarea name="body" rows="4" cols="50" class="form-control-text body" placeholder="Nội dung"></textarea>
                            </div>
                        </div>
						<div class="form-group row">
                            <label class="col-lg-2 col-form-label" for="val-username">Đường dẫn <span class="text-danger"></span></label>
                            <div class="col-lg-10">
                              <input type="text" name="url" class="form-control url" placeholder="Đường dẫn">
                            </div>
                        </div>		
						<div class="form-group row">
			                <label class="col-lg-4 col-form-label" for="sel_idposttype">Kiểu post <span class="text-danger"></span></label>
			                <div class="col-lg-8">
			                    <select class="form-control sel_idposttype" name="sel_idposttype">
			                    	<option value="">Chọn kiểu post</option>
			                    	@foreach($svposttypes as $row)
			                    		 <option value="{{ $row['id_post_type'] }}">{{ $row['name'] }}</option>
									@endforeach        
			                    </select>
			                </div>
			            </div>
						<div class="form-group row">
			                <label class="col-lg-4 col-form-label" for="sel_idcategory">Chuyên mục <span class="text-danger"></span></label>
			                <div class="col-lg-8">
			                    <select class="form-control sel_idcategory" name="sel_idcategory">
			                    	<option value="">Thuộc chuyên mục</option>
			                    	@foreach($categories as $row)
			                    		 <option value="{{ $row['idcategory'] }}">{{ $row['name'] }}</option>
									@endforeach        
			                    </select>
			                </div>
			            </div>
                     
                        <div class="form-group row">
                            <div class="col-lg-12 text-center">
                                <button type="button" class="btn btn-primary btn-submit">Xác nhận</button>
                            </div>
                        </div>

                    </form>
                </div>

            </div>
        </div>
		 
		 </div>
  </div>
@stop
@section('other_scripts')
   <script src="{{ asset('public/js/customer.js?v=1.1.0') }}"></script> 
@stop