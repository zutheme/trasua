<?php
    function show_all_menu($categories, $idparent = 0, $char = 0) {
        $cate_child = array();
        $arr_parent = array();
        foreach ($categories as $key => $item) {
            if($item['idparent'] == $idparent) {
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }                    
        if ($cate_child) {
            if(!$char){
                echo '<ul class="nav navbar-nav c-theme-nav">';
            }else{
                echo '<ul class="dropdown-menu c-menu-type-classic c-pull-left">';
            }
            foreach ($cate_child as $key => $item) {
                // Hiển thị tiêu đề chuyên mục
                if($item['depth']==0){
                    $span1 =' class="c-link dropdown-toggle"';
                    $span2 = ' <span class="c-arrow c-toggler"></span>';
                    $span3= ' class="c-menu-type-classic"';
                }else {
                    $span1 = '';
                    $span2 = '';
                    $span3 = '';
                }
                //echo '<li'.$span3.'><a href="#"'.$span1.'>'.$char.'--'.$item['namemenu'].'--'.$item['depth'].$span2.'</a>';
                echo '<li'.$span3.'><a href="#"'.$span1.'>'.$item['namemenu'].$span2.'</a>';
                // Tiếp tục đệ quy để tìm chuyên mục con của chuyên mục đang lặp
                $char++;
                show_all_menu($categories, $item['idmenuhascate'], $char);
                echo '</li>';
            } ?>
            <li class="c-search-toggler-wrapper"><a href="#" class="c-btn-icon c-search-toggler"><i class="fa fa-search"></i></a></li>
            <li class="c-cart-toggler-wrapper">
            <a href="{{ url('teamilk/shopcart') }}" class="c-btn-icon c-cart-toggler"><i class="icon-handbag c-cart-icon"></i> <span class="c-cart-number c-theme-bg">0</span></a></li>
            <?php echo '</ul>';
        } 
    } ?>
 <nav class="c-mega-menu c-pull-right c-mega-menu-dark c-mega-menu-dark-mobile c-fonts-uppercase c-fonts-bold menu-home">
        <?php show_all_menu($rs_menu, 0, ''); ?>             
</nav>