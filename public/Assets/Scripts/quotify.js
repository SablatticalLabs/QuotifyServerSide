

jQuery(function ($) {
	// Load dialog on page load
	//$('#basic-modal-content').modal();

	// Load dialog on click
	$('#iphone').click(function (e) {
		$('#basic-modal-content').modal();

		return false;
	});

	//'download now' link
	$('#main #subhead .download').live('click',function(){

		$(this).find('img').click();

	});

});