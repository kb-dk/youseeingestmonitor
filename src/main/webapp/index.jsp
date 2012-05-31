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
%>
<html lang="en">
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
            <a class="brand" href="#">Ingest Monitor</a>

            <div class="navbar-form pull-left btn-toolbar">
                <div class="btn-group" data-toggle="buttons-radio">
                    <button class="btn" id="inprogress">In Progress</button>
                    <button class="btn" id="failed">Failed</button>
                    <button class="btn" id="done">Done</button>
                </div>

                <div class="btn-group" data-toggle="buttons-radio">
                    <button class="btn" id="day">Today</button>
                    <button class="btn" id="week">Last 7 days</button>
                    <button class="btn" id="all">All</button>
                </div>

                <div class="btn-group">
                    <button class="btn" id="reload"><span class="icon-refresh"></span>Reload</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <h1><span id="header">Files</span></h1>
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
<script type="text/javascript" src="bbq/jquery.ba-bbq.min.js">
</script>
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js">
</script>
<script type="text/javascript">
    function show(state) {
        var items = [];
        $.each(state, function(id, content) {
            allStatesLink = $.deparam.fragment().mode != 'details'
                    ? ' <a href="#" onClick="$.bbq.pushState(\'#mode=details&file=' + content.entity.name
                    + '\', 0); return false">(show all states)</a>' : '';
            items.push('<tr><td>' + content.entity.name + allStatesLink + '</td><td>' + new Date(content.date)
                               + '</td><td>' + content.component + ': ' + content.stateName + '</td><td>' + (content
                    .message == null ? '' : content.message) + '</td></tr>');
        });

        $('<tbody/>', {
            'class': 'my-new-list',
            html: items.join('')
        }).replaceAll('tbody');

    }

    function update(path, title, allStates) {
        $('#header').replaceWith('<span id="header">' + title + '</span>');
        $.getJSON('<%= WORKFLOWSTATEMONITOR_SERVICE %>' + path, show);
    }

    function hashchange(e) {
        var datequery;
        switch ($.deparam.fragment().period) {
            case 'day':
                var today = new Date();
                datequery = "&startDate=" + today.getFullYear() + "-" + ("0" + (today.getMonth() + 1)).slice(-2) + "-"
                        + ("0" + today.getDate()).slice(-2);
                break;
            case 'week':
                var thisweek = new Date();
                thisweek.setDate(thisweek.getDate() - 7);
                datequery = "&startDate=" + thisweek.getFullYear() + "-" + ("0" + (thisweek.getMonth() + 1)).slice(-2)
                        + "-" + ("0" + thisweek.getDate()).slice(-2);
                break;
            case 'all':
            default:
                datequery = "";
                break;
        }

        switch ($.deparam.fragment().mode) {
            case 'failed':
                update('states/?includes=<%= FAILED_STATE %>&onlyLast=true' + datequery, 'Failed files', true);
                break;
            case 'done':
                update('states/?includes=<%= DONE_STATE %>&onlyLast=true' + datequery, 'Completed files', true);
                break;
            case 'details':
                update('states/' + $.deparam.fragment().file + '?' + datequery,
                       'Details for ' + $.deparam.fragment().file);
                break;
            case 'inprogress':
            default:
                update('states/?excludes=<%= DONE_STATE %>&excludes=<%= FAILED_STATE %>&onlyLast=true' + datequery,
                       'Files in progress', true);
        }
    }

    $(document).ready(function() {
        $(window).bind('hashchange', hashchange);
        hashchange();

        $("#inprogress").click(function() {
            $.bbq.pushState("#mode=inprogress&file=", 0);
        });

        $("#failed").click(function() {
            $.bbq.pushState("#mode=failed&file=", 0);
        });

        $("#done").click(function() {
            $.bbq.pushState("#mode=done&file=", 0);
        });

        $("#day").click(function() {
            $.bbq.pushState("#period=day", 0);
        });

        $("#week").click(function() {
            $.bbq.pushState("#period=week", 0);
        });

        $("#all").click(function() {
            $.bbq.pushState("#period=all", 0);
        });

        $("#reload").click(function() {
            hashchange();
        });
    })
</script>
</body>
</html>