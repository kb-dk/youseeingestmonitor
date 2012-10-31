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
<%
    String FAILED_STATE = application.getInitParameter("failed-state");
    String DONE_STATE = application.getInitParameter("done-state");
    String STOPPED_STATE = application.getInitParameter("stopped-state");
    String RESTARTED_STATE = application.getInitParameter("restarted-state");
    String WORKFLOWSTATEMONITOR_SERVICE = application.getInitParameter("workflowstatemonitorservice");
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
    <link href="datepicker/css/datepicker.css" rel="stylesheet">
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

            <div class="btn-group nav">
                <div class="input-append date nav" id="dp" data-date-format="yyyy-mm-dd">
                    <input class="span2" size="16" type="text" value="1970-01-01" readonly />
                    <span class="add-on"><i class="icon-calendar"></i></span>
                </div>
            </div>

            <div class="btn-group nav">

                <button class="btn" id="reload"><span class="icon-refresh"></span>Reload</button>
            </div>

            <ul class="nav pull-right">
              <li><a href="index.jsp">States</a></li>
              <li class="active">
                  <a href="overview.jsp">Overview</a>
              </li>
            </ul>
        </div>
    </div>
</div>

<div class="container">
    <h1><span id="header">Overview</span></h1>
    <table class="table">
        <thead>
        <tr>
            <th>Channel</th>
            <th>00</th>
            <th>01</th>
            <th>02</th>
            <th>03</th>
            <th>04</th>
            <th>05</th>
            <th>06</th>
            <th>07</th>
            <th>08</th>
            <th>09</th>
            <th>10</th>
            <th>11</th>
            <th>12</th>
            <th>13</th>
            <th>14</th>
            <th>15</th>
            <th>16</th>
            <th>17</th>
            <th>18</th>
            <th>19</th>
            <th>20</th>
            <th>21</th>
            <th>22</th>
            <th>23</th>
        </tr>
        </thead>
        <tbody id="statetable">
        </tbody>
    </table>
    <div>
        <span id="errors"></span>
    </div>
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
<script type="text/javascript" src="datepicker/js/bootstrap-datepicker.js">
</script>
<script type="text/javascript">
    function show(state) {
        state.sort(function(el1, el2) {
            var filename1 = el1.entity.name;
            var filename2 = el2.entity.name;
            var channel1 = filename1.substring(0, filename1.indexOf("_"));
            var channel2 = filename2.substring(0, filename2.indexOf("_"));
            var time1;
            try {
                time1 = parseInt(filename1.split('-')[4].split('.')[0], 10);
            } catch (e) {
                time1 = 0;
            }
            try {
                var time2 = parseInt(filename2.split('-')[4].split('.')[0], 10);
            } catch (e) {
                time2 = 0;
            }
            if ((channel1 < channel2) || ((channel1 == channel2) && (time1 < time2))) {
                return -1
            }
            if ((channel1 > channel2) || ((channel1 == channel2) && (time1 > time2))) {
                return 1
            }
            return 0;
        });

        var items = [];
        var unparsed = [];
        var curChannel = '';
        var curTime = 0;
        function pad(until) {
            while (curTime < until) {
                items.push('<td bgcolor="white">&nbsp;</td>');
                curTime++;
            }
        }
        function endRow() {
            if (items.length != 0) {
                pad(24);
                items.push('</tr>');
            }
        }

        $.each(state, function(id, content) {
            try {
                var filename = content.entity.name;
                var channel = filename.substring(0, filename.indexOf("_"));
                var time = parseInt(filename.split('-')[4].split('.')[0], 10);
                if (channel != curChannel) {
                    endRow();
                    curChannel = channel;
                    curTime = 0;
                    items.push('<tr><td>' + channel + '</td>');
                }
                pad(time);
                if (curTime == time) {
                    switch (content.stateName) {
                        case '<%= DONE_STATE %>':
                            items.push('<td style="background-color: green; text-align: center"><a href="<%= DELIVERY_HTTP_PREFIX %>' + encodeURIComponent(content.entity.name) + '"><i class="icon-play"></i></a></td>');
                            // TODO Replace direct links with playlist
                            break;
                        case '<%= STOPPED_STATE %>':
                        case '<%= FAILED_STATE %>':
                            items.push('<td style="background-color: red; text-align: center"><a href="index.jsp#file=' + encodeURIComponent(content.entity.name) + '&mode=details"><i class="icon-warning-sign"></i></a></td>');
                            break;
                        case '<%= RESTARTED_STATE %>':
                        default:
                            items.push('<td style="background-color: yellow; text-align: center"><a href="index.jsp#file=' + encodeURIComponent(content.entity.name) + '&mode=details"><i class="icon-list"></i></a></td>');
                            break;

                    }
                    curTime++;
                } else {
                    unparsed.push('Unexpected: ' + content + '<br/>');
                }
            } catch (e) {
                unparsed.push('Unexpected: ' + content + '<br/>');
            }
        });
        endRow();

        $('<tbody/>', {
            'class': 'my-new-list',
            'id': 'statetable',
            html: items.join('')
        }).replaceAll('#statetable');

        $('<span>', {
            'class': 'my-new-list',
            'id': 'statetable',
            html: unparsed.join('')
        }).replaceAll('#errors');

        $("[rel=tooltip]").tooltip();
    }

    function formatDate(date) {
        return date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-"
                                        + ("0" + date.getDate()).slice(-2);
    }

    function update() {
        var today;
        var dateString = $.deparam.fragment().date;
        if (dateString && dateString.match("^[0-9]{4}-[0-9]{2}-[0-9]{2}$")) {
            var dateStrings = dateString.split("-");
            today = new Date(parseInt(dateStrings[0], 10), parseInt(dateStrings[1], 10) - 1, parseInt(dateStrings[2], 10));
        } else {
            today = new Date();
        }
        $('#header').replaceWith('<span id="header">Overview of ' + formatDate(today) + '</span>');
        $('#dp').find('input')[0].value = formatDate(today);
        $('#dp').datepicker('update');
        var tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);
        var startDate = formatDate(today);
        var endDate = formatDate(tomorrow);
        $.getJSON('<%= WORKFLOWSTATEMONITOR_SERVICE %>states?onlyLast=true&startDate=' + startDate + '&endDate=' + endDate, show);
        // TODO: What if last state is from another day?
    }

    function hashchange(e) {
        update();
    }

    $(document).ready(function() {
        $(window).bind('hashchange', hashchange);
        $('#dp').datepicker().on('changeDate', function(ev) {
            $.bbq.pushState("#date=" + formatDate(ev.date));
            $('#dp').datepicker('hide');
        });
        hashchange();

        $("#reload").click(function() {
            hashchange();
        });
    });
</script>
</body>