$(".block form[id='delete_form']").submit(function() {
	if($("form input[type='checkbox'][name!='check_all']:checked").size() < 1){
		alert('请选择组件');
		return false;
	}
	return true;
});

$(".block form[id='search_form'] input[type='text']").keydown(function(e) {
	if(e.keyCode == 13)
		$(".block form[id='search_form']").submit();
});