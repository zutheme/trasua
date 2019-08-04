<!-- BEGIN: CONTENT/SHOPS/SHOP-1-5 -->
<div class="c-content-box c-size-md">
	<div class="c-content-tab-5 c-bs-grid-reset-space c-theme">
		<!-- Nav tabs -->
		<ul class="nav nav-pills c-nav-tab c-arrow" role="tablist">
			<li role="presentation" class="active">
				<a class="c-font-uppercase" href="#watches5" aria-controls="watches" role="tab" data-toggle="tab">Yêu thích</a>
			</li>
			<li role="presentation">
				<a class="c-font-uppercase" href="#phone5" aria-controls="phone" role="tab" data-toggle="tab">Thịnh hành</a>
			</li>
			<li role="presentation">
				<a class="c-font-uppercase" href="#imac5" aria-controls="imac" role="tab" data-toggle="tab">Xu hướng</a>
			</li>
			<li role="presentation">
				<a class="c-font-uppercase" href="#accessories5" aria-controls="accessories" role="tab" data-toggle="tab">Bán nhanh</a>
			</li>
		</ul>
		<!-- Tab panes -->
		<div class="tab-content">
			<div role="tabpanel" class="tab-pane fade in active" id="watches5">
				<div class="row">
					@if(isset($teamilks1))
						@foreach($teamilks1 as $row)
						<div class="col-md-3 col-sm-6">
							<div class="c-content c-content-overlay">
								<div class="c-overlay-wrapper c-overlay-padding">
									<div class="c-overlay-content">
										<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>
									</div>
								</div>
								<div class="c-bg-img-center c-overlay-object" data-height="height" style="height: 270px; background-image: url({{ asset( $row['urlfile'] ) }});"></div>
								<div class="c-overlay-border"></div>
							</div>
						</div>
						@endforeach
					@endif
				</div>
			</div>

			<div role="tabpanel" class="tab-pane fade" id="phone5">
				<div class="row">
					@if(isset($teamilks1))
						@foreach($teamilks1 as $row)
						<div class="col-md-3 col-sm-6">
							<div class="c-content c-content-overlay">
								<div class="c-overlay-wrapper c-overlay-padding">
									<div class="c-overlay-content">
										<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>
									</div>
								</div>
								<div class="c-bg-img-center c-overlay-object" data-height="height" style="height: 270px; background-image: url({{ asset( $row['urlfile'] ) }});"></div>
								<div class="c-overlay-border"></div>
							</div>
						</div>
						@endforeach
					@endif
				</div>
			</div>

			<div role="tabpanel" class="tab-pane fade" id="imac5">
				<div class="row">
					@if(isset($teamilks1))
						@foreach($teamilks1 as $row)
						<div class="col-md-3 col-sm-6">
							<div class="c-content c-content-overlay">
								<div class="c-overlay-wrapper c-overlay-padding">
									<div class="c-overlay-content">
										<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>
									</div>
								</div>
								<div class="c-bg-img-center c-overlay-object" data-height="height" style="height: 270px; background-image: url({{ asset( $row['urlfile'] ) }});"></div>
								<div class="c-overlay-border"></div>
							</div>
						</div>
						@endforeach
					@endif
				</div>
			</div>

			<div role="tabpanel" class="tab-pane fade" id="accessories5">
				<div class="row">
					@if(isset($teamilks1))
						@foreach($teamilks1 as $row)
						<div class="col-md-3 col-sm-6">
							<div class="c-content c-content-overlay">
								<div class="c-overlay-wrapper c-overlay-padding">
									<div class="c-overlay-content">
										<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>
									</div>
								</div>
								<div class="c-bg-img-center c-overlay-object" data-height="height" style="height: 270px; background-image: url({{ asset( $row['urlfile'] ) }});"></div>
								<div class="c-overlay-border"></div>
							</div>
						</div>
						@endforeach
					@endif
				</div>
			</div>
		</div>
	</div>
</div><!-- END: CONTENT/SHOPS/SHOP-1-5 -->
