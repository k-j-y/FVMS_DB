<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="jsp.Bean.model.*"
	import="java.io.PrintWriter" import="jsp.DB.method.*"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	
	PrintWriter script =  response.getWriter();
	if (session.getAttribute("sessionID") == null){
		script.print("<script> alert('세션의 정보가 없습니다.'); location.href = '../login.jsp' </script>");
	}
	String sessionID = (String)session.getAttribute("sessionID");
	
	int no = Integer.parseInt(request.getParameter("no"));
	int year = Integer.parseInt(request.getParameter("year"));
	String place = request.getParameter("place");
	ProjectDAO projectDao = new ProjectDAO();
	int result = 0;
	result = projectDao.updateData(no, place, "근무지", year);
	if(result == 1){
		script.print("<script> alert('수정되었습니다.'); location.href = 'project.jsp#state"+no+"'</script>");
	}else{
		script.print("<script> alert('실패하였습니다.'); location.href = 'project.jsp#state"+no+"' </script>");
	}
%>
</body>
</html>