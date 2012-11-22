<%--
  #%L
  Yousee Ingest Monitor
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
    String STOPPED_STATE = application.getInitParameter("stopped-state");
    String RESTARTED_STATE = application.getInitParameter("restarted-state");
    String WORKFLOWSTATEMONITOR_SERVICE = application.getInitParameter("workflowstatemonitorservice");
    String SCRATCH_DELIVERY_HTTP_PREFIX = application.getInitParameter("scratchdeliveryhttpprefix");
    String DELIVERY_HTTP_PREFIX = application.getInitParameter("deliveryhttpprefix");
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

            <div class="btn-group nav" data-toggle="buttons-radio">
                <button class="btn" id="inprogress"><i class="icon-play"></i> In Progress</button>
                <button class="btn" id="failed"><i class="icon-warning-sign"></i> Failed</button>
                <button class="btn" id="details" style="display: none;"><i class="icon-list"></i> Details</button>
                <button class="btn" id="stopped"><i class="icon-stop"></i> Stopped</button>
                <button class="btn" id="done"><i class="icon-ok"></i> Done</button>
            </div>

            <div class="btn-group nav" data-toggle="buttons-radio">
                <button class="btn" id="day"><i class="icon-time"></i> Today</button>
                <button class="btn" id="week"><i class="icon-list-alt"></i> Last 7 days</button>
                <button class="btn" id="all"><i class="icon-calendar"></i> All</button>
            </div>

            <div class="btn-group nav">
                <button class="btn" id="reload"><span class="icon-refresh"></span>Reload</button>
            </div>

            <ul class="nav pull-right">
              <li class="active">
                <a href="index.jsp">States</a>
              </li>
              <li><a href="overview.jsp">Overview</a></li>
            </ul>
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
            <th>Actions</th>
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
    function htmlEscape(string) {
        return string.replace('&', "&amp;").replace('"', "&quot;").replace("'", "&#39;").replace('>', "&gt;").replace('<', "&lt;")
    }

    function show(state) {
        var items = [];
        $.each(state, function(id, content) {
            var allStatesLink = '<a rel="tooltip" title="Show all individual states this file has gone through." href="#" class="btn" onclick="$.bbq.pushState(\'#mode=details&file=' + encodeURIComponent(content
                    .entity.name) + '\', 0); return false"><i class="icon-list"></i> Show all states</a>';
            var stopLink = '<a href="#" rel="tooltip" title="Do not retry downloading this file on errors." class="btn" onclick="stop(\'' + content.entity.name + '\'); return false"><i class="icon-stop"></i> Stop</a>';
            var restartLink = '<a href="#" rel="tooltip" title="Retry downloding this file." class="btn" onclick="restart(\'' + content.entity.name + '\'); return false"><i class="icon-play"></i> Restart</a>';

            var playLink = '<a class="btn" href="play.jsp?file=' + encodeURIComponent(state == "<%= DONE_STATE %>" ? '<%= DELIVERY_HTTP_PREFIX %>' : '<%= SCRATCH_DELIVERY_HTTP_PREFIX %>'
                       + encodeURIComponent($.deparam.fragment().file)) + '"><i class="icon-play"></i> Play</a>'

            var item = "<tr>";
            item += "<td>" + content.entity.name + "</td>";
            item += "<td>" + new Date(content.date) + "</td>";
            item += "<td>" + content.component + ": " + content.stateName + "</td>";
            item += "<td style=\"white-space: pre-wrap\">" + (content.message == null ? '' : htmlEscape(content.message)) + "</td>";
            item += "<td><div class=\"btn-group\">";
            if ($.deparam.fragment().mode != 'details') {
                item += allStatesLink;
            }
            if ($.deparam.fragment().mode != 'details' && content.stateName != "<%= DONE_STATE %>" && content.stateName
                    != "<%= STOPPED_STATE %>") {
                item += stopLink;
            }
            if ($.deparam.fragment().mode != 'details' && content.stateName != "<%= RESTARTED_STATE %>") {
                item += restartLink;
            }
            if ($.deparam.fragment().mode != 'details' || ($.deparam.fragment().mode == 'details' && items.length == 1 )) {
                item += playLink;
            }
            item += "</div></td>";
            item += "</tr>";
            items.push(item);
        });

        $('<tbody/>', {
            'class': 'my-new-list',
            html: items.join('')
        }).replaceAll('tbody');
        $("[rel=tooltip]").tooltip();
    }

    function stop(name) {
        $.ajax({
                   type: "POST",
                   url: '<%= WORKFLOWSTATEMONITOR_SERVICE %>' + 'states/' + name,
                   contentType: "application/json",
                   data: JSON.stringify({component: 'yousee_ingest_monitor', stateName: '<%= STOPPED_STATE %>'})
               }).done(hashchange);
        $.bbq.pushState("#mode=details&file=" + name, 0);
    }

    function restart(name) {
        $.ajax({
                   type: "POST",
                   url: '<%= WORKFLOWSTATEMONITOR_SERVICE %>' + 'states/' + name,
                   contentType: "application/json",
                   data: JSON.stringify({component: 'yousee_ingest_monitor', stateName: '<%= RESTARTED_STATE %>'})
               }).done(hashchange);
        $.bbq.pushState("#mode=details&file=" + name, 0);
    }

    function update(path, title) {
        $("[rel=tooltip]").tooltip('hide');
        $('#header').replaceWith('<span id="header">' + title + '</span>');
        $.getJSON('<%= WORKFLOWSTATEMONITOR_SERVICE %>' + path, show);
    }

    function hashchange(e) {
        var datequery;
        switch ($.deparam.fragment().period) {
            case 'day':
                $('#day').button('toggle');
                var today = new Date();
                datequery = "&startDate=" + today.getFullYear() + "-" + ("0" + (today.getMonth() + 1)).slice(-2) + "-"
                        + ("0" + today.getDate()).slice(-2);
                break;
            case 'week':
                $('#week').button('toggle');
                var thisweek = new Date();
                thisweek.setDate(thisweek.getDate() - 7);
                datequery = "&startDate=" + thisweek.getFullYear() + "-" + ("0" + (thisweek.getMonth() + 1)).slice(-2)
                        + "-" + ("0" + thisweek.getDate()).slice(-2);
                break;
            case 'all':
            default:
                $('#all').button('toggle');
                datequery = "";
                break;
        }

        switch ($.deparam.fragment().mode) {
            case 'failed':
                $('#failed').button('toggle');
                update('states/?includes=<%= FAILED_STATE %>&onlyLast=true' + datequery, 'Failed files');
                break;
            case 'stopped':
                $('#stopped').button('toggle');
                update('states/?includes=<%= STOPPED_STATE %>&onlyLast=true' + datequery, 'Stopped files');
                break;
            case 'done':
                $('#done').button('toggle');
                update('states/?includes=<%= DONE_STATE %>&onlyLast=true' + datequery, 'Completed files');
                break;
            case 'details':
                $('#details').button('toggle');
                update('states/' + $.deparam.fragment().file + '?' + datequery,
                       'Details for ' + $.deparam.fragment().file);
                break;
            case 'inprogress':
            default:
                $('#inprogress').button('toggle');
                update('states/?excludes=<%= DONE_STATE %>&excludes=<%= FAILED_STATE %>&excludes=<%= STOPPED_STATE %>&onlyLast=true'
                               + datequery, 'Files in progress');
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

        $("#stopped").click(function() {
            $.bbq.pushState("#mode=stopped&file=", 0);
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
