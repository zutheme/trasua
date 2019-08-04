<div class="c-content-box c-size-md c-bg-white">

	<div class="container">

		<div class="c-content-title-1">

			<h3 class="c-center c-font-uppercase c-font-bold">Thẩm mỹ nội khoa</h3>

			<div class="c-line-center"></div>

		</div>

		<!-- BEGIN: CONTENT/SHOPS/SHOP-2-7 -->

		<div class="c-bs-grid-small-space">

			@if(isset($teamilks2))

					<?php $count = 0; ?>

					@foreach($teamilks2 as $row)

						@if($count%4 == 0) <div class="row"> @endif				

							<div class="col-md-3 col-sm-6 c-margin-b-20">

								<div class="c-content-product-2 c-bg-white c-border">

									<div class="c-content-overlay">

										<div class="c-overlay-wrapper">

											<div class="c-overlay-content">

												<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>

											</div>

										</div>

										<div class="c-bg-img-center c-overlay-object" data-height="height" style="height: 230px; background-image: url({{ asset($row['urlfile']) }});"></div>

									</div>

									<div class="c-info">

										<p class="c-title c-font-16 c-font-slim">{{ $row['namepro'] }}</p>

										<p class="c-price c-font-14 c-font-slim"><span class="currency">{{ $row['price'] }}</span><span class="vnd"></span> &nbsp;

											<span class="c-font-14 c-font-line-through c-font-red"><span class="currency">{{ $row['price'] }}</span><span class="vnd"></span></span>

										</p>

									</div>

									<div class="btn-group btn-group-justified" role="group">

										<div class="btn-group c-border-top" role="group">

											<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-sm c-btn-white c-btn-uppercase c-btn-square c-font-grey-3 c-font-white-hover c-bg-red-2-hover c-btn-product">Thích</a>

										</div>

										<div class="btn-group c-border-left c-border-top" role="group">

											<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-sm c-btn-white c-btn-uppercase c-btn-square c-font-grey-3 c-font-white-hover c-bg-red-2-hover c-btn-product">Mua</a>

										</div>

									</div>

								</div>

							</div>

							<?php $count++; ?>

							@if($count%4 == 0) </div> @endif

					@endforeach

				@endif

		</div><!-- END: CONTENT/SHOPS/SHOP-2-7 -->

	</div>

</div>