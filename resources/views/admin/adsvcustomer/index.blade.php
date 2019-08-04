@extends('admin.dashboard')

@section('other_styles')
    <!-- Datatables -->
      <link href="{{ asset('dashboard/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css') }}" rel="stylesheet">
      <link href="{{ asset('dashboard/vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css') }}" rel="stylesheet">
      <link href="{{ asset('dashboard/vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css') }}" rel="stylesheet">
      <link href="{{ asset('dashboard/vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css') }}" rel="stylesheet">
      <link href="{{ asset('dashboard/vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css') }}" rel="stylesheet">
    
     <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.2') }}" rel="stylesheet">
@stop

@section('content')
   <div class="row">
   	<div class="x_content">
	        <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                <div align="right">
						<a class="btn btn-default btn-primary" href="{{ URL::route('admin.adsvcustomer.create') }}">Thêm mới</a>
					</div>
                  <div class="x_title">
                     @if($message = Session::get('success'))
			        	<h2 class="card-subtitle">{{ $message }}</h2>
					@endif               
                  </div>
                  <div class="x_content">
                   <table id="datatable" class="table table-striped table-bordered">
                      <thead>
	                    <tr>
	                        <th>Ngày</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th>Điện thoại</th>
							<th>Địa chỉ</th>
							<th>Nghề nghiệp</th>
							<th>Ghi chú</th>
							<th>-</th>
							<th>-</th>
							<th>-</th>
	                    </tr>
	                </thead>
	                <tfoot>
	                    <tr>
	                       <th>Ngày</th>
							<th>Họ tên</th>
							<th>Email</th>
							<th>Điện thoại</th>
							<th>Địa chỉ</th>
							<th>Nghề nghiệp</th>
							<th>Ghi chú</th>
							<th></th>
							<th></th>
							<th></th>
	                    </tr>
	                </tfoot>
	                <tbody>
	                	@foreach($svcustomers as $row)
							<tr>
								<td>{{ $row['created_at'] }}</td>
								<td>{{ $row['firstname'] }}</td>
								<td>{{ $row['email'] }}</td>
								<td>{{ $row['mobile'] }}</td>
								<td>{{ $row['address'] }}</td>
								<td>{{ $row['job'] }}</td>
								<td>{{ $row['note'] }}</td>
								<td class="btn-control-action">
								    <a class="btn btn-primary btn-action" href="javascript:void(0)"><i class="fa fa-comments-o"></i></a>
								 </td>
								<td class="btn-control"><a class="btn btn-primary btn-edit" href="{{ action('Admin\AdsvcustomerController@edit',$row['idcustomer']) }}"><i class="fa fa-edit"></i></a></td>
								<td class="btn-control">
								     <form method="post" class="delete_form" action="{{action('Admin\AdsvcustomerController@destroy', $row['idcustomer'])}}">
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
        <div class="x_content"> 
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
			                    		 <option value="{{ $row['idcategory'] }}">{{ $row['namecat'] }}</option>
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
@stop
@section('other_scripts')  
  <!-- Datatables -->
    <script src="{{ asset('dashboard/vendors/datatables.net/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-bs/js/dataTables.bootstrap.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-buttons/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-buttons/js/buttons.flash.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-buttons/js/buttons.html5.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-buttons/js/buttons.print.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-keytable/js/dataTables.keyTable.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-responsive/js/dataTables.responsive.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/datatables.net-scroller/js/dataTables.scroller.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/jszip/dist/jszip.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/pdfmake/build/pdfmake.min.js') }}"></script>
    <script src="{{ asset('dashboard/vendors/pdfmake/build/vfs_fonts.js') }}"></script>
      <!-- Custom Theme Scripts -->
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script>
   	<script src="{{ asset('dashboard/production/js/customer.js?v=0.0.4') }}"></script>
@stop