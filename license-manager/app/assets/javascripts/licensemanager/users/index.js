
function changeStatus() {
	var selected = $('form select option:selected').val();
	var users_lock = $("input[name='is_lock']");
	users_lock.each(function() {
		var temp = this.value.split('_');
		if((selected == 'lock' && temp[0] == "true") || (selected == 'unlock' && temp[0] == "false")) {
			$("form input[type='checkbox'][value='" + temp[1] + "']").removeAttr('checked');
			$("form input[type='checkbox'][value='" + temp[1] + "']").attr('disabled', 'disabled');
		} else if(selected == 'lock' && temp[0] == "false" || (selected == 'unlock' && temp[0] == "true")) {
			$("form input[type='checkbox'][value='" + temp[1] + "']").removeAttr('disabled');
		} else {
			$("form input[type='checkbox'][value='" + temp[1] + "']").removeAttr('disabled');
		}
	});
}


$(".block form[id='search_form'] input[type='text']").keydown(function(e) {
	if(e.keyCode == 13)
		$(".block form[id='search_form']").submit();
});

$(".block form[id='lock_form']").submit(function() {
	var selected = $('form select option:selected').val()
	if(selected == '' || selected == null) {
		alert('请选择要执行的动作');
		return false;
	} else if($("form input[type='checkbox'][name!='check_all']:checked").size() < 1) {
		alert('请选择用户');
		return false;
	}
	return true;
});

$('form select').change(function() {
	changeStatus();
});

$(document).ready(function() {
	changeStatus();
});
