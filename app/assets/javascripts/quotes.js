$(document).ready(function() {
  if($("#quote").height() > 112) { 
    offset = $("#quote").height() - 112;
    $("#thumbnail").css("top", 200 + offset);
    $("#comments").css("top", offset);
  }
});