<%--
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
  --%><!DOCTYPE html>
<% String FAILED_STATE = application.getInitParameter("failed-state");
   String DONE_STATE = application.getInitParameter("done-state");
   String WORKFLOWSTATEMONITOR_SERVICE = application.getInitParameter("workflowstatemonitorservice");
%><html lang="en">
<head>
    <title>Ingest Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Ingest Monitor">
    <meta name="author" content="The State and University Library, Denmark">

    <!-- Le styles -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
        body {
            padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
        }
    </style>
    <link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
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
            <a class="brand" href="index.jsp">Ingest Monitor</a>

            <div class="nav-collapse">
                <div class="btn-group">
                    <button class="btn" id="inprogress">In Progress</button>
                    <button class="btn" id="failed">Failed</button>
                    <button class="btn" id="done">Done</button>
                </div>
            </div>
            <!--/.nav-collapse -->
        </div>
    </div>
</div>

<div class="container">
    <h1>Files</h1>
    <table class="table">
        <thead>
        <tr>
            <th>File</th>
            <th>Date</th>
            <th>State</th>
            <th>Message</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<!-- /container -->

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
            items.push('<tr><td>' + content.entity.name + ' <a href="#" onClick="update(\'states/' + content.entity.name
                               + '/\', \'Details for ' + content.entity.name
                               + '\'); return false">(details)</a></td><td>' + new Date(content.date) + '</td><td>'
                               + content.component + ': ' + content.stateName + '</td><td>' + (content.message == null
                    ? '' : content.message) + '</td></tr>');
        });

        $('<tbody/>', {
            'class': 'my-new-list',
            html: items.join('')
        }).replaceAll('tbody');

    }

    function update(path, title) {
        $('h1').replaceWith('<h1>' + title + '</h1>');
        $.getJSON('<%= WORKFLOWSTATEMONITOR_SERVICE %>' + path, show);
    }

    $(document).ready(function() {
        update('states/?excludes=<%= DONE_STATE %>&excludes=<%= FAILED_STATE %>&onlyLast=true', 'Files in progress');

        $("button#inprogress").click(function() {
            update('states/?excludes=<%= DONE_STATE %>&excludes=<%= "failed" %>&onlyLast=true', 'Files in progress');
        });

        $("button#failed").click(function() {
            update('states/?includes=<%= "failed" %>&onlyLast=true', 'Failed files');
        });

        $("button#done").click(function() {
            update('states/?includes=<%= DONE_STATE %>&onlyLast=true', 'Completed files');
        });
    })
</script>
</body>
</html>