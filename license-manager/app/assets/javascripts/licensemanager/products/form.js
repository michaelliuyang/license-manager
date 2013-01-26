
$('form').submit(function() {
	var msg = '';
	var flag = false;
	if($('#product_name').val() == "")
		msg = '组件命名不能为空';
	else if($('#product_value').val() == "")
		msg = '组件值不能为空';
	if(msg != '') {
		$('.block .message p').html(msg);
		$('.block .message').fadeIn('slow');
	} else {
		flag = true;
	}
	return flag;
});
