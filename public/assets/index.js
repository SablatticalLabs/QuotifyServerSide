

jQuery(function ($) {
	// Load dialog on page load
	//$('#basic-modal-content').modal();

	// Load dialog on click
	$('.video, #mid').click(function (e) {
		$('#basic-modal-content').modal();

		return false;
	});

	//'download now' link
	$('#main #subhead .download').live('click',function(){

		$(this).find('img').click();

	});

	// close modal
	$("#simplemodal-overlay").live('click',function(e){
		
		$('#simplemodal-container').remove();
		$('#simplemodal-overlay').remove();

	});

	// comment submit 
	$('#submitcomment input[type="submit"]').live('click',function(e){
		
		mixpanel.track("New Comment Submission");
		alert('commenting coming soon!');
		e.preventDefault();

	});
});