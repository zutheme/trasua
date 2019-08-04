$(document).ready(function(){
    $('#myDatepicker1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss'
    });
    $('#myDatepicker2').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss'
    });
    // $("#myDatepicker2").on("dp.change", function(e) {
    //$("input[name='_start_date']").val(_start_date_sl);
    // });
    // $('yourpickerid').on('changeDate', function(ev){
    //     $(this).datepicker('hide');
    // });
    if(_start_date_sl&&_end_date_sl){
        $("input[name='_start_date']").val(_start_date_sl);
        $("input[name='_end_date']").val(_end_date_sl);
    }else{
      //var str_start = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" "+today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
      var today = new Date();
      var str_start = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" 00:00:00";
      var str_end = today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" 23:59:59";
        $("input[name='_start_date']").val(str_start);
        $("input[name='_end_date']").val(str_end);
    }
});