// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require lib/underscore
//= require lib/backbone
//= require lib/backbone-rails-sync
//= require lib/backbone-datalink
//= require lib/jquery-sensible-datetime
//= require lib/jquery.placeholder.min
//= require lib/bootstrap-dropdown
//= require lib/jquery.mentionsInput
//= require lib/waypoints.min
//= require backbone/app
$(function() {
 $('input, textarea').placeholder();
 $.ajaxSetup({
   beforeSend: function( xhr ) {
     var token = $('meta[name="csrf-token"]').attr('content');
     if (token) xhr.setRequestHeader('X-CSRF-Token', token);
   }
 });
});
