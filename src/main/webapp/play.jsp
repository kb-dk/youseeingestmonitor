<%
    response.setContentType("application/text");
    String file = request.getParameterValues("file")[0];
    response.setHeader("Content-disposition","attachment; filename="
            + file.replaceAll("\\.[^.]*$", ".m3u").substring(file.lastIndexOf('/') + 1));
    response.getOutputStream().write(file.getBytes());
%>