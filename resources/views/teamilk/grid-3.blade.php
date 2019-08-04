<!-- BEGIN: CONTENT/ISOTOPE/GRID-3 -->

<div class="c-content-box c-size-md c-bg-img-center" style="background-image: url({{ asset('assets-tea/assets/base/img/content/backgrounds/bg-82.jpg') }})">

	<div class="container">

		<div class="c-content-title-1">

			<h3 class="c-center c-font-uppercase c-font-bold c-font-white">Trị nám tàn nhang</h3>

			<div class="c-line-center c-theme-bg"></div>

		</div>

		<div class="c-content-isotope-grid c-opt-3">

			@if(isset($teamilks))

				@foreach($teamilks as $row)

					<div class="c-content-isotope-item">

						<div class="c-content-isotope-image-container">

							<img class="c-content-isotope-image" src="{{ asset($row['urlfile']) }}">

							<div class="c-content-isotope-overlay">

								<div class="c-content-isotope-overlay-content">

									<h3 class="c-content-isotope-overlay-title c-font-white c-font-uppercase">{{ $row['namepro'] }}</h3>

									<p class="c-content-isotope-overlay-price c-font-white c-font-bold"><span class="currency">{{ $row['price'] }}</span><span class="vnd"></span></p>

									<p class="c-content-isotope-overlay-desc c-font-white">{{ $row['short_desc'] }}</p>

									<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="c-content-isotope-overlay-btn btn c-btn-white c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square btn-cart">Thêm vào giỏ</a>

									<input type="hidden" class="idproduct" name="idproduct" value="{{ $row['idproduct'] }}">

									<a href="javascript:;" class="c-content-isotope-overlay-btn btn c-btn-white c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square btn-whist">Yêu thích</a>

								</div>

							</div>

						</div>

					</div>

				@endforeach

			@endif

			

		</div>

	</div> 

</div><!-- END: CONTENT/ISOTOPE/GRID-3 -->