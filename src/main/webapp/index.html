<!--
  #%L
  Ingest monitor webpage
  %%
  Copyright (C) 2012 The State and University Library, Denmark
  %%
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  #L%
  -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Ingest Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Ingest Monitor">
    <meta name="author" content="The State and University Library, Denmark">

    <!-- Le styles -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Ingest Monitor</a>
          <div class="nav-collapse">
	    <div class="btn-group">
	      <button class="btn" id="inprogress">In Progress</button>
	      <button class="btn" id="failed">Failed</button>
	      <button class="btn" id="done">Done</button>
	    </div>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">
<h1>Files</h1>
<table class="table">
<thead>
<th>File</th><th>Date</th><th>State</th><th>Message</th>
</thead>
<tbody>
</tbody>
    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="jquery/jquery-1.7.2.min.js">
    </script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js">
    </script>
    <script type="text/javascript">
        function show(state) {
        var items = [];
        $.each(state, function(id, content) {
            items.push('<tr><td>' + content.entity.name + ' <a href="#" onClick="$.getJSON(\'/workflowstatemonitor/states/' + content.entity.name + '/\', show);$(&quot;h1&quot;).replaceWith(&quot;&lt;h1&gt;Details for ' + content.entity.name + '&lt;/h1&gt;&quot;); return false">(details)</a></td><td>' + new Date(content.date) + '</td><td>' + content.component + ': ' + content.stateName + '</td><td>' + (content.message == null ? '' : content.message) + '</td></tr>');
        });

        $('<tbody/>', {
            'class': 'my-new-list',
            html: items.join('')
        }).replaceAll('tbody');

	}

        $("h1").replaceWith("<h1>Files in progress</h1>");
	$.getJSON('/workflowstatemonitor/states/?excludes=done&onlyLast=true', show);

$(document).ready(function(){
	$("button#inprogress").click(function(){
	    $.getJSON('/workflowstatemonitor/states/?excludes=done&onlyLast=true', show);
            $("h1").replaceWith("<h1>Files in progress</h1>");
	});

	$("button#failed").click(function(){
	    $.getJSON('/workflowstatemonitor/states/?includes=failed&onlyLast=true', show);
            $("h1").replaceWith("<h1>Failed files</h1>");
	});

	$("button#done").click(function(){
	    $.getJSON('/workflowstatemonitor/states/?includes=done&onlyLast=true', show);
            $("h1").replaceWith("<h1>Completed files</h1>");
	});
})
    </script>
</body>
