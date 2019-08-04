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

      <link href="{{ asset('dashboard/production/css/custom.css?v=0.3.8') }}" rel="stylesheet">

      <!-- bootstrap-daterangepicker -->

      <link href="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.css') }}" rel="stylesheet">

      <!-- bootstrap-datetimepicker -->

      <link href="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.css') }}" rel="stylesheet">

@stop

@section('content')
<?php if(isset($rs_orderproduct)) {
    $unit_price = 0;
    $subtotal = 0;
  } ?>
   <div class="col-md-12 col-sm-12 col-xs-12">

                <div class="x_panel">

                  <div class="x_title">
                    @if(isset($errors))
                      {{ $errors }}
                    @endif
                     @if($message = Session::get('error'))
                          <h2 class="card-subtitle">{{ $message }}</h2>
                     @endif
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        {{-- <ul class="dropdown-menu" role="menu">
                          <li><a href="#">Settings 1</a>
                          </li>
                          <li><a href="#">Settings 2</a>
                          </li>
                        </ul>  --}}      
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  
                  <div class="x_content">
                    <p class="text-muted font-13 m-b-30"></p>
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                          <tr>
                              <th>Hình ảnh</th>
                              <th>Mô Tả</th>   
                              <th>Đơn giá</th>
                              <th>Số Lượng</th>
                              <th>Thành giá</th>
                              <th>Ghi chú</th>    
                           </tr>
                       </thead>
                       
                          <tbody>
                            @if(isset($rs_orderproduct))
                              @foreach($rs_orderproduct as $row)
                                @if( $row['parentidproduct'] == 0 )
                                    <?php $idproductparent = $row['idproduct']; 
                                        $unit_price = $row['price'];
                                    ?>
                                    <tr>                     
                                      <td><a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}"><img width="100%" class="thumb" src="{{ asset($row['urlfile']) }}"></a></td>
                                      <td><ul class="c-list list-unstyled">
                                            <li class="c-margin-b-25"><h2><a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="c-font-bold c-font-22 c-theme-link">{{ $row['namepro'] }}</a></h2></li>
                                            <ul class="cart-list-topping">
                                              @foreach($rs_orderproduct as $item)
                                                @if($item['parentidproduct'] == $idproductparent )
                                                  <li>&nbsp;&nbsp;<label>{{ $item['namepro'] }}</label>&nbsp;&nbsp;<span class="currency">{{ $item['price'] }}</span><span class="vnd"></span></li>
                                                  <?php $unit_price = $unit_price + $item['price']; ?>
                                                @endif
                                              @endforeach 
                                            </ul>
                                             <li><p>{{ $row['short_desc'] }}</p></li>
                                          </ul>
                                       
                                      </td>
                                      <td><span class="currency">{{ $unit_price }}</span><span class="vnd"></span></td>
                                      <td>{{ $row['amount'] }}</td>
                                      <?php $unitprice_quality = $unit_price*$row['amount'] ; ?>
                                      <td><span class="currency">{{ $unitprice_quality }}</span><span class="vnd"></span></td>
                                      <td>{{ $row['note'] }}</td>     
                                    </tr>
                                  <?php $subtotal = $subtotal + $unitprice_quality; ?>
                                @endif
                              @endforeach
                            @endif                 
                      </tbody>
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>Tổng</td>
                        <td><span class="currency">{{ $subtotal }}</span><span class="vnd"></span></td>
                        <td>-</td>    
                     </tr>
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>Phí vận chuyển</td>
                        <td><span class="currency">0000</span><span class="vnd"></span></td>
                        <td>-</td>    
                     </tr>
                      <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>Tổng cộng</td>
                        <td><span class="currency">{{ $subtotal }}</span><span class="vnd"></span></td>
                        <td></td>
                      </tr> 
                  </table>
                  
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

    <script src="{{ asset('dashboard/vendors/moment/min/moment.min.js') }}"></script>

    <script src="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.js') }}"></script>

    <!-- bootstrap-datetimepicker -->    

    <script src="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js') }}"></script>

      <!-- Custom Theme Scripts -->

    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}

    <script src="{{ asset('dashboard/build/js/custom.js?v=0.0.3') }}"></script>

    {{-- <script src="{{ asset('dashboard/production/js/custom.js?v=0.0.2') }}"></script> --}}

    {{-- <script src="{{ asset('dashboard/production/js/customer.js?v=0.6.4') }}"></script> --}}

@stop