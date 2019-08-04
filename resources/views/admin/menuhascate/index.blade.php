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
    <link href="{{ asset('dashboard/production/css/menuhascate.css?v=0.3.2') }}" rel="stylesheet">
@stop
<?php $_namecattype = Request::segment(3);
$_namecattype = isset($_namecattype) ? Request::segment(3) : 'product'; ?>
@section('content')
<script type="text/javascript">
		var temp_categories =[]; var tmpi = 0;
</script>
@foreach($rs_list_cate as $row)
	<script type="text/javascript">	
      	temp_categories[tmpi] = { idmenuhascate: '{{ $row['idmenuhascate'] }}', idmenu:'{{ $row['idmenu'] }}', idcategory:'{{ $row['idcategory'] }}', namemenu:'{{ $row['namemenu'] }}' ,idparent:'{{ $row['idparent'] }}', reorder:'{{ $row['reorder'] }}', depth:'{{ $row['depth'] }}', trash:'{{ $row['trash'] }}' };
      	tmpi = tmpi + 1; 
	</script>
@endforeach
<script type="text/javascript">
	localStorage.removeItem("lmn_items");
    localStorage.setItem('lmn_items', JSON.stringify(temp_categories));
</script>
   <div class="row">
		<div class="col-sm-12 menuhascate">
			<div class="card">
		    	<div class="card-body">
		        <h4 class="card-title">Menu</h4>
				<div class="col-sm-4">
					<form class="frm-create-category" method="post" action="{{ action('Admin\MenuHasCateController@store') }}" >
						{{ csrf_field() }}
						<div class="form-group">
			                    <select class="form-control type-category" name="sel_idcattype" required="true">
			                    	<option value="">Kiểu chuyên mục</option>
			                    	@foreach($categorytypes as $row)
			                    		<option value="{{ $row['idcattype'] }}">{{ $row['catnametype'] }}</option>
									@endforeach        
			                    </select>
			            </div>
						<div class="form-group">
		                    <div class="catebyidcatetype">     
		                    </div>
		                   {{--  <a href="javascript:void(0)" onclick="AddCateToMenu();" class="btn btn-default btn-primary">Thêm vào</a> --}}
			            </div>
			            <div class="form-group">
			            	 <input type="hidden" class="idmenu" name="_idmenu" value="">
			            	 <input type="hidden" class="obj-add-cate" name="obj_add_cate" value="">
			            	 <input type="button" onclick="return AddCateToMenu();" class="btn btn-default btn-primary" name="btn-submit" value="Thêm vào" />
			            </div>
			        </form>
				</div>
				<div class="col-sm-8">
					<form class="frm_menuhascate" method="post" action="{{ action('Admin\MenuHasCateController@update',$idmenu) }}" >
						{{ csrf_field() }}
						<input type="hidden" name="_method" value="PATCH">
			            <div class="col-lg-6">
			                <select class="form-control cus-drop" name="sel_idmenu" required="true">
			                	<option value="">Chọn ...</option>
			                	@foreach($rs_menu as $row)
			                	<option value="{{ $row['idmenu'] }}" {{ $row['idmenu'] == app('request')->input('idmenu') ? 'selected="selected"' : '' }}>{{ $row['namemenu'] }}</option>
								@endforeach        
			                </select>
			            </div>      
						<div class="col-lg-6"><a class="btn btn-default btn-primary" href="{{ action('Admin\MenuController@create') }}">Tạo mới</a></div>
						<div class="col-lg-12">
							<div class="table-menu">
				            	<div class="menu"></div>
				        	</div>
				        </div>
				        <div class="col-lg-6">
				        	<input type="hidden" class="obj-menu" name="objmenu" value="">
				        </div>
			            <div class="col-lg-6">
							<input type="button" onclick="return re_order_block();" class="btn btn-default btn-primary" name="btn-submit" value="Lưu menu" />
						</div>
						@if(count($list) > 0)
							{{ $list }}
						@endif
						@if($message = Session::get('success'))
				        	<h6 class="card-subtitle">{{ $message }}</h6>
				        @elseif($message = Session::get('error'))
				        	<h6 class="card-subtitle">{{ $message }}</h6>
						@endif
						
			            <p id="demo"></p>
			            <p id="enter"></p>
			            <p id="dragstart"></p>
			            <p id="dragleave"></p>
			           	<p id="dragend"></p>
			           	<p id="xy"></p>
		           	</form>
		        </div>
		    	</div>
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
    {{-- <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script> --}}
    <script src="{{ asset('dashboard/production/js/menuhascate2.js?v=0.4.0.9') }}"></script>
@stop