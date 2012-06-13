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
                    <button class="btn" id="inprogress"><i class="icon-play"></i> In Progress</button>
                    <button class="btn" id="failed"><i class="icon-warning-sign"></i> Failed</button>
                    <button class="btn" id="details" style="display: none;"><i class="icon-list"></i> Details</button>
                    <button class="btn" id="stopped"><i class="icon-stop"></i> Stopped</button>
                    <button class="btn" id="done"><i class="icon-ok"></i> Done</button>
                </div>

                <div class="btn-group" data-toggle="buttons-radio">
                    <button class="btn" id="day"><i class="icon-time"></i> Today</button>
                    <button class="btn" id="week"><i class="icon-list-alt"></i> Last 7 days</button>
                    <button class="btn" id="all"><i class="icon-calendar"></i> All</button>
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
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<!-- /container -->

<div class="modal hide" id="stopModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>Warning: This file may still be processed in the ingest workflow</h3>
    </div>
    <div class="modal-body">
        <p>
            The file is not in an end state of the workflow.
            This indicates that the file is still being processed or that the workflow has stopped unexpectedly
            with an error. If the file is still processed, your request to stop the file may be ignored.
        </p>

        <p>
            Press OK if you believe that the workflow has stopped unexpectedly and don't want the ingest workflow to
            try to ingest the file again.
        </p>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">Cancel</a>
        <a id="confirmStop" href="#" class="btn btn-primary">OK</a>
    </div>
</div>

<div class="modal hide" id="restartModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>Warning: This file may still be processed in the ingest workflow</h3>
    </div>
    <div class="modal-body">
        <p>
            The file is not in an end state of the workflow.
            This indicates that the file is still being processed or that the workflow has stopped unexpectedly
            with an error. If the file is still processed, your request to restart the file may be ignored.
        </p>

        <p>
            Press OK if you believe that the workflow has stopped unexpectedly and want the ingest workflow to
            try to ingest the file again.
        </p>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">Cancel</a>
        <a id="confirmRestart" href="#" class="btn btn-primary">OK</a>
    </div>
</div>
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
            var allStatesLink = '<a rel="tooltip" title="Show all individual states this file has gone through." href="#" class="btn" onclick="$.bbq.pushState(\'#mode=details&file=' + content
                    .entity.name + '\', 0); return false"><i class="icon-list"></i> Show all states</a>';
            var stopLink = '<a href="#" rel="tooltip" title="Do not retry downloading this file on errors." class="btn" onclick="stop(\'' + content.entity.name + "\',\'" + content.stateName
                    + '\'); return false"><i class="icon-stop"></i> Stop</a>';
            var restartLink = '<a href="#" rel="tooltip" title="Retry downloding this file." class="btn" onclick="restart(\'' + content.entity.name + "\',\'" + content.stateName
                    + '\'); return false"><i class="icon-play"></i> Restart</a>';

            var item = "<tr>";
            item += "<td>" + content.entity.name + "</td>";
            item += "<td>" + new Date(content.date) + "</td>";
            item += "<td>" + content.component + ": " + content.stateName + "</td>";
            item += "<td>" + (content.message == null ? '' : content.message) + "</td>";
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

    function stop(name, stateName) {
        if (stateName != "<%= DONE_STATE %>" && stateName != "<%= STOPPED_STATE %>" && stateName != "<%= FAILED_STATE %>") {
            $("#stopModal").attr("data-name", name);
            $("#stopModal").modal();
        } else {
            doStop(name);
        }
    }

    function doStop(name) {
        $.ajax({
                   type: "POST",
                   url: '<%= WORKFLOWSTATEMONITOR_SERVICE %>' + 'states/' + name,
                   contentType: "application/json",
                   data: JSON.stringify({component: 'yousee_ingest_monitor', stateName: '<%= STOPPED_STATE %>'})
               }).done(hashchange);
    }

    function restart(name, stateName) {
        if (stateName != "<%= DONE_STATE %>" && stateName != "<%= STOPPED_STATE %>" && stateName != "<%= FAILED_STATE %>") {
            $("#restartModal").attr("data-name", name);
            $("#restartModal").modal();
        } else {
            doRestart(name);
        }
    }

    function doRestart(name) {
        $.ajax({
                   type: "POST",
                   url: '<%= WORKFLOWSTATEMONITOR_SERVICE %>' + 'states/' + name,
                   contentType: "application/json",
                   data: JSON.stringify({component: 'yousee_ingest_monitor', stateName: '<%= RESTARTED_STATE %>'})
               }).done(hashchange);
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

        $("#confirmStop").click(function() {
            var name = $("#stopModal").attr("data-name");
            doStop(name);
            $("#stopModal").modal('hide');
            return false;
        });

        $("#confirmRestart").click(function() {
            var name = $("#restartModal").attr("data-name");
            doRestart(name);
            $("#restartModal").modal('hide');
            return false;
        });
    })
</script>
</body>
</html>