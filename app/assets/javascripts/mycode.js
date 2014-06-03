
  $(function() { var other_tax = ["delivery charge","freight","packaging","cutting charge","postage and telegram"];
  var tax_rated = ["14.5","5.5","5","2"];
  var no_tin = ["29000000000"];
    $("#suggested").autocomplete({
    	source: other_tax
    });
    $("#customer_tin").autocomplete({
    	source: no_tin
    });
    $("#tax_rate").autocomplete({
    	source: tax_rated
    });
    $( ".dialog-form" ).dialog({
      autoOpen: false,
      modal: true,
      close : clearForm
    });
    $( ".taxog-form" ).dialog({
      autoOpen: false,
      modal: true,
      close : clearForm
    });
    $( "#popup-form" ).dialog({
      autoOpen: false,
      modal: true,
      close : clearForm
    });
     $( "#catup-form" ).dialog({
      autoOpen: false,
      modal: true,
      close : clearForm
    });
     $( "#taxup-form" ).dialog({
      autoOpen: false,
      modal: true,
      close : clearForm
    });
    $("#halibut").click(function()
    {if ( $("#date_start").val() && $("#date_end").val() ) 
    	{$.ajax({url: "/microposts.xml",type: "GET",target:'_self',data: {'start_date':$("#date_start").val(),'end_date':$("#date_end").val()}});}
     else{
     	alert("please choose period ");
     	
     }
     
    }
   );
    
    
    $(document).ready(function() {
   $('.hidden').hide();
   
 });
 $(document).tooltip();
 $("#refresh-hold").hide();
 $(".appear").hide();
 $("#bill-bid").hide();
 $("#deliver-list").hide();
 $("#deliver-holder").hide();
 
 $('#messpin').hide();
 $('.datePicker').datepicker({
 	dateFormat: "yy-mm-dd"

 });
 $('#start_date').datepicker({
 	dateFormat: "yy-mm-dd",
 	defaultDate: "-1M",
    changeMonth: true,
    
 }).datepicker("setDate","-1M");
 $('#end_date').datepicker({
 	dateFormat: "yy-mm-dd",
 	setDate:"+0",

 }).datepicker("setDate", "0");
 
 
 
 $("#refresh-hold").hide();
  $(".help").click(function(){
		$(".dialog-form").dialog("open");
	});
	 $(".taxup").click(function(){
		$(".taxog-form").dialog("open");
	});
	$("#hide_customer").click(function(){
		$(".appear").hide();
		
	});
	$("#spinneret").click(function(){
		$("#spinme").spin();
		$("#messpin").show();
	});
	$("#add_customer").click(function(){
		if($(".appear").is(":hidden")){
		$(".appear").show("blind");}
	});
	$("#bill-bid").click(function(){
		if($("#bill-form").is(":hidden")){
		$("#bill-form").show("blind");
		$("#add_customer").show();}
	});
  });
  function clearForm(form)
{
    $(":input", form).each(function()
    {
    var type = this.type;
    var tag = this.tagName.toLowerCase();
    	if (type == 'text')
    	{
    	this.value = "";
    	}
    });
};
  
  
	
	