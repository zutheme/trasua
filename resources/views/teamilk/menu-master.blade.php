<?php
    function show_all_menu($categories, $idparent = 0, $char = 0, $depth = 0) {
        $cate_child = array();
        $arr_parent = array();
        foreach ($categories as $key => $item) {
            if($item['idparent'] == $idparent) {
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }                   
        if ($cate_child) {
            $depth_ul = $depth;
            if(!$char){
                echo '<ul class="nav navbar-nav c-theme-nav">';
            }else{
                if($depth_ul == 0){
                    echo '<ul class="dropdown-menu c-menu-type-classic c-pull-left">';
                }else if($depth_ul == 1){
                    echo '<ul class="dropdown-menu c-pull-right '.$depth_ul.'">';
                }else {
                    echo '<ul class="dropdown-menu c-pull-left '.$depth_ul.'">';
                }
            }
            foreach ($cate_child as $key => $item) {
                // Hiển thị tiêu đề chuyên mục
                $depth_li = $item['depth'];
                if($depth_li==0){
                    $span1 =' class="c-link dropdown-toggle"';
                    $span2 = ' <span class="c-arrow c-toggler"></span>';
                    $span3= ' class="c-menu-type-classic"';
                }else if($depth_li==1){
                    $span1 = '';
                    $span2 = '';
                    $span3 = ' class="dropdown-submenu"';
                }else if ($depth_li==2) {
                    $span1 = '';
                    $span2 = '';
                    $span3 = ' class="dropdown-submenu"';
                }elseif ($depth_li==3) {
                    $span1 = '';
                    $span2 = '';
                    $span3 = ' class="dropdown-submenu"';
                } 
                else {
                    $span1 = '';
                    $span2 = '';
                    $span3 = '';
                }
                //echo '<li'.$span3.'><a href="#"'.$span1.'>'.$char.'--'.$item['namemenu'].'--'.$item['depth'].$span2.'</a>';
                echo '<li'.$span3.'><a href="'.url('/').'/teamilk/listproductbyidcate/'.$item['idcategory'].'/10/1/10'.'"'.$span1.'>'.$item['namemenu'].$span2.'</a>';
                $char++;
                show_all_menu($categories, $item['idmenuhascate'], $char, $item['depth']); 
                echo "</li>";
            }  
            echo '</ul>';
        } 
    } ?>
<ul class="hidden-menu" style="display: none;">
<li class="c-search-toggler-wrapper">
    <a href="#" class="c-btn-icon c-search-toggler"><i class="fa fa-search"></i></a></li>
<li class="c-cart-toggler-wrapper">
    <a href="{{ url('teamilk/shopcart') }}" class="c-btn-icon c-cart-toggler"><i class="icon-handbag c-cart-icon"></i> <span class="c-cart-number c-theme-bg">0</span></a></li>
<li class="user-profile"> 
    @if (Auth::check())
    <a href="{{ url('/profile') }}/{{ Auth::id() }}" class="c-btn-border-opacity-04 c-btn btn-no-focus c-btn-header btn btn-sm c-btn-border-1x c-btn-dark c-btn-circle c-btn-uppercase c-btn-sbold "><img src="{{ asset($url_avatar) }}">{{ Auth::user()->name }}</a> 
    @else
    <a href="#" data-toggle="modal" data-target="#login-form" class="c-btn-border-opacity-04 c-btn btn-no-focus c-btn-header btn btn-sm c-btn-border-1x c-btn-dark c-btn-circle c-btn-uppercase c-btn-sbold"><i class="icon-user"></i> Đăng nhập</a>
    @endif
</li>
</ul> 
 <nav class="c-mega-menu c-pull-right c-mega-menu-dark c-mega-menu-dark-mobile c-fonts-uppercase c-fonts-bold menu-home">
        <?php show_all_menu($rs_menu, 0, ''); ?>             
</nav>