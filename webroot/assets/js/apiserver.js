var apis = {};

apis.init = function() {
	$("#newgroup").on('click', (function () {
								apis.makeGroup();
								}));
	$(".newdoc").on('click', (function () {
								apis.makeDoc($(this).attr('data-def'));
								}));
	$(".editdoc").on('click', (function () {
							  apis.startEditDoc($(this).attr('data-def'));
							  }));
	$(".editusagedoc").on('click', (function () {
							   apis.startEditUsage($(this).attr('data-def'));
							   }));

	// docs
	$(".canceldocbutton").on('click', (function () {
									   $("#docid"+$(this).attr('data-def')+" > .display").show()
									   $("#docid"+$(this).attr('data-def')+" > .editor").hide()
									   return false;
									   }));
	$(".savedocbutton").on('click', (function () {
									 apis.saveDoc($(this).attr('data-def'));
									 $("#docid"+$(this).attr('data-def')+" > .display").show()
									 $("#docid"+$(this).attr('data-def')+" > .editor").hide()
									 return false;
									 }));

	// usage
	$(".cancelusagebutton").on('click', (function () {
									   $("#routeusage"+$(this).attr('data-def')+" > .display").show()
									   $("#routeusage"+$(this).attr('data-def')+" > .editor").hide()
									   return false;
									   }));
	$(".saveusagebutton").on('click', (function () {
									 apis.saveUsage($(this).attr('data-def'));
									 $("#routeusage"+$(this).attr('data-def')+" > .display").show()
									 $("#routeusage"+$(this).attr('data-def')+" > .editor").hide()
									 return false;
									 }));


};

apis.makeGroup = function() {
	var name = prompt("Please enter a name for this API Group", "");
	if (name != null) {
		var options = {}
		options.name = name;
		$.ajax({
			   beforeSend: function(request) {
			   request.setRequestHeader("Authorization", "Bearer "+headerToken);
			   request.setRequestHeader("x-csrf-token", csrf);
			   request.setRequestHeader("Content-Type", "application/json");
			   },
			   type: "POST",
			   url: "/api/v1/groups/create",
			   data: JSON.stringify(options),
			   contentType: "application/json",
			   dataType: "json"
			   })
		.done(function(d) {
			  $("#groups").html(apis.makeLeft(d));
			  });
	}

}

apis.makeDoc = function(grp) {
	var name = prompt("Please enter a name for this API Document Entry", "");
	if (name != null) {
		var options = {}
		options.name = name;
		options.groupid = grp;
		$.ajax({
			   beforeSend: function(request) {
			   request.setRequestHeader("Authorization", "Bearer "+headerToken);
			   request.setRequestHeader("x-csrf-token", csrf);
			   request.setRequestHeader("Content-Type", "application/json");
			   },
			   type: "POST",
			   url: "/api/v1/docs/create",
			   data: JSON.stringify(options),
			   contentType: "application/json",
			   dataType: "json"
			   })
		.done(function(d) {
			  $("#groups").html(apis.makeLeft(d));
			  return false
			  });
	}

}

apis.saveDoc = function(id) {
	var options = {}
	options.id = id;
	options.name = $("#docidnameeditor"+id).val();
	options.docs = $("#docideditor"+id).val();
	options.id = id;
	$.ajax({
		   beforeSend: function(request) {
		   request.setRequestHeader("Authorization", "Bearer "+headerToken);
		   request.setRequestHeader("x-csrf-token", csrf);
		   request.setRequestHeader("Content-Type", "application/json");
		   },
		   type: "POST",
		   url: "/api/v1/docs/save/doc",
		   data: JSON.stringify(options),
		   contentType: "application/json",
		   dataType: "json"
		   })
	.done(function(d) {
		  $("#groups").html(apis.makeLeft(d));
		  $("#nameelement"+id).html(d["name"]);
		  $("#docdata"+id).html(d["docs"]);
		  return false
		  });

}

apis.saveUsage = function(id) {
	var options = {}
	options.id = id;
	options.usage = $("#docidusageeditor"+id).val();
	options.id = id;
	$.ajax({
		   beforeSend: function(request) {
		   request.setRequestHeader("Authorization", "Bearer "+headerToken);
		   request.setRequestHeader("x-csrf-token", csrf);
		   request.setRequestHeader("Content-Type", "application/json");
		   },
		   type: "POST",
		   url: "/api/v1/docs/save/usage",
		   data: JSON.stringify(options),
		   contentType: "application/json",
		   dataType: "json"
		   })
	.done(function(d) {
		  $("#groups").html(apis.makeLeft(d));
		  $("#docdatausage"+id).html(d["usage"]);
		  return false
		  });

}


apis.makeLeft = function(d) {
	var html = "";
	$.each( d.list, function( index, i ) {
		   html += '<p class="mt"><a href="/#'+i.id+'">'+i.name+'</a>'
		   html += '<a href="#" class="newdoc" data-def="'+i.id+'"><span class="icon-plus r"></span></a>'
		   $.each( i.docs, function( index, doc ) {
				  html += '<p class="pl"><a href="/#'+doc.id+'">'+doc.name+'</a></p>'
				  });

		   html += '</p>'
		   });
	$("#groups").html(html);

}

apis.startEditDoc = function(id){
	$("#docid"+id+" > .display").hide()
	$("#docid"+id+" > .editor").show()
}

apis.startEditUsage = function(id){
	$("#routeusage"+id+" > .display").hide()
	$("#routeusage"+id+" > .editor").show()
}


$(document).ready(function() {
  apis.init();
});
