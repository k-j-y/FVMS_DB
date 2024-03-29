<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.io.PrintWriter"
	import="jsp.DB.method.*" import="jsp.Bean.model.*"
	import="java.util.ArrayList" import="java.util.List"
	import="java.text.SimpleDateFormat" import="java.util.Date"%>
	
<!DOCTYPE html>
<html lang="en">

<head>
<%
		PrintWriter script =  response.getWriter();
		if (session.getAttribute("sessionID") == null){
			script.print("<script> alert('세션의 정보가 없습니다.'); location.href = '../login.jsp' </script>");
		}
		
		int permission = Integer.parseInt(session.getAttribute("permission").toString());
		if(permission != 0){
			script.print("<script> alert('접근 권한이 없습니다.'); history.back(); </script>");
		}
			
		String sessionID = session.getAttribute("sessionID").toString();
		String sessionName = session.getAttribute("sessionName").toString();
		
		String id = request.getParameter("id");
		
		SummaryDAO summaryDao = new SummaryDAO();
		MemberDAO memberDao = new MemberDAO();
		ManagerDAO managerDao = new ManagerDAO();
		
		Date nowTime = new Date();
		SimpleDateFormat sf_yyyy = new SimpleDateFormat("yyyy");
		String nowYear = sf_yyyy.format(nowTime);
		int year = Integer.parseInt(sf_yyyy.format(nowTime));
		
		ArrayList<rankPeriodBean> rank_period_list = managerDao.getPeriod(id);
		MemberBean memberInfo = memberDao.returnMember(id);
%>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Sure FVMS - Personal Management</title>

<!-- Custom fonts for this template-->
<link href="../../vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
	rel="stylesheet">

<!-- Custom styles for this template-->
<link href="../../css/sb-admin-2.min.css" rel="stylesheet">


<style>
.sidebar .nav-item {
	word-break: keep-all;
}

#sidebarToggle {
	display: none;
}

.sidebar {
	position: relative;
	z-index: 997;
}

#manager_btn {
	position: fixed;
	bottom: 0;
	padding: 10px;
	width: 100%;
	text-align: center;
	background-color: #fff;
	border-top: 1px solid;
}

.m-0 .text-primary {
	vertical-align: middle;
	text-align: center;
}

.loading {
	position: fixed;
	text-align: center;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	font-size: 8px;
	background-color: #4e73df6b;
	background-image: linear-gradient(181deg, #3d5482 16%, #6023b654 106%);
	background-size: cover;
	z-index: 1000;
	color: #ffffffc4;
}

.loading #load {
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}

th, td{
	border: 1px solid white;
	padding: 7px;
	text-align: center;
}

th {
	background-color: #4e73df54;
}

td {
	background-color: #ecedf0;
}

@media ( max-width :765px) {
	.wpTable {
		padding: 5px;
		width: 100%;
	}
	#sidebarToggle {
		display: block;
	}
	.extra {
		display: none;
	}
	.card-header {
		margin-top: 4.75rem;
	}
	.sidebar .nav-item {
		white-space: nowrap !important;
		font-size: x-large !important;
	}
	.topbar {
		z-index: 999;
		position: fixed;
		width: 100%;
	}
	#accordionSidebar {
		width: 100%;
		height: 100%;
		text-align: center;
		display: inline;
		padding-top: 60px;
		position: fixed;
		z-index: 998;
	}
	#content {
		margin-left: 0;
	}
	.nav-item {
		position: absolute;
		display: inline-block;
		padding-top: 20px;
	}
	.topbar .dropdown {
		padding-top: 0px;
	}
	.container-fluid {
		padding: 0;
	}
	.card-header:first-child {
		padding: 0;
	}
	.table-responsive {
		width: 100%;
		margin-left: 0;
	}
}
</style>

<!-- sorting table -->
<script type="text/javascript" src="https://code.jquery.com/jquery-2.2.4.js"></script>
<script type="text/javascript" src="jquery.tablednd.js"></script>
<script type="text/javascript">
	window.onbeforeunload = function () { $('.loading').show(); }  //현재 페이지에서 다른 페이지로 넘어갈 때 표시해주는 기능
	$(window).load(function () {          //페이지가 로드 되면 로딩 화면을 없애주는 것
	    $('.loading').hide();
	});
</script>
</head>
<body id="page-top">
	<!--  로딩화면  시작  -->
	<div class="loading">
		<div id="load">
			<i class="fas fa-spinner fa-10x fa-spin"></i>
		</div>
	</div>
	<!--  로딩화면  끝  -->
	<!-- Page Wrapper -->
	<div id="wrapper">
		<!-- Sidebar -->
		<ul
			class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion toggled"
			id="accordionSidebar">
			<!-- Sidebar - Brand -->

			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../mypage/mypage.jsp"> <i class="fas fa-fw fa-table"></i>
					<span>마이페이지</span></a></li>

			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../summary/summary.jsp"> <i class="fas fa-fw fa-table"></i>
					<span>수입 요약</span></a></li>

			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../expense_sum/expense_sum.jsp"> <i
					class="fas fa-fw fa-table"></i> <span>지출 요약</span></a></li>

			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../profit_analysis/profit_analysis.jsp"> <i
					class="fas fa-fw fa-table"></i> <span>수익성 분석</span></a></li>

			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../memchart/memchart.jsp"> <i class="fas fa-fw fa-table"></i>
					<span>조직도</span></a></li>

			<!-- Nav Item - project -->
			<li class="nav-item"><a class="nav-link"
				href="../project/project.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>프로젝트 관리</span></a></li>

			<!-- Nav Item - schedule -->
			<li class="nav-item"><a class="nav-link"
				href="../schedule/schedule.jsp"> <i
					class="fas fa-fw fa-calendar"></i> <span>스케줄 - 엔지니어</span></a></li>

			<li class="nav-item"><a class="nav-link"
				href="../project_schedule/project_schedule.jsp"> <i
					class="fas fa-fw fa-calendar"></i> <span>스케줄 - 프로젝트</span></a></li>

			<!-- Nav Item - manager schedule -->
			<li class="nav-item"><a class="nav-link"
				href="../manager_schedule/manager_schedule.jsp"> <i
					class="fas fa-fw fa-calendar"></i> <span>스케줄 - 관리자</span></a></li>

			<!-- Nav Item - report -->
			<li class="nav-item"><a class="nav-link"
				href="../report/report.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>프로젝트 주간보고</span></a></li>

			<!-- Nav Item - meeting -->
			<li class="nav-item"><a class="nav-link"
				href="../meeting/meeting.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>고객미팅 회의록</span></a></li>

			<!-- Nav Item - meeting -->
			<li class="nav-item"><a class="nav-link"
				href="../assessment/assessment.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>평가</span></a></li>

			<!-- Nav Item - manager page -->
			<%
				if (permission == 0) {
			%>
			<li class="nav-item active"><a class="nav-link"
				href="../manager/manager.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>관리자 페이지</span></a></li>
			<%
				}
			%>
		</ul>
		<!-- End of Sidebar -->

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

					<!-- Sidebar Toggle (Topbar) -->
					<button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
						<i class="fa fa-bars"></i>
					</button>


					<!-- Topbar Navbar -->
					<ul class="navbar-nav ml-auto">
						<!-- Nav Item - User Information -->
						<li class="nav-item dropdown no-arrow">
							<a class="nav-link dropdown-toggle" href="#" id="userDropdown"
							role="button" data-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false">
								<span class="mr-2 d-none d-lg-inline text-gray-600 small"><%=sessionName%></span>
								<i class="fas fa-info-circle"></i>
							</a> <!-- Dropdown - User Information -->
							<div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
								<a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal"> 
									<i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
									Logout
								</a>
							</div>
						</li>
					</ul>

				</nav>
				<!-- End of Topbar -->

				<!-- Begin Page Content -->
				<div class="container-fluid">
					<div class="card shadow mb-4">
					
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary" id="view_btn"><%=memberInfo.getNAME() %> 인사 관리 페이지
							<%if(memberInfo.getOutDate().equals("-")){ %>
							<input type="button" value="퇴사 처리" style="float: right; font-size: small;" class="btn btn-primary" onclick="location.href='resign.jsp?id=<%=id%>&rank=<%=memberInfo.getRANK()%>'">
							<%} %>
							</h6>
						</div>
						
						<form method="POST" action="savePeriod.jsp">
						<div class="table-responsive" style="padding: 20px">
							<input type="hidden" name="id" value="<%=id %>">
							<input type="hidden" name="cnt" value="<%=rank_period_list.size() %>">
							<table  style="margin-bottom: 20px;">
								<tr>
									<th style="width: 70px;">입사일</th>
									<td style="width: 360px;">
										<input type="date" name="comDate" id="comDate" style="width:160px;" value="<%=memberInfo.getComDate() %>" max="9999-12-31">
									</td>
								</tr>
								<tr>
									<th style="width: 70px;">퇴사일</th>
									<td style="width: 360px;">
										<input type="date" name="outDate" id="outDate" style="width:160px;" value="<%=memberInfo.getOutDate() %>" max="9999-12-31">
									</td>
								</tr>
							</table>
							<table id="InfoTable">
								<tr>
									<th style="width: 70px;">직급</th>
									<th style="width: 180px;">시작 날짜</th>
									<th style="width: 180px;">종료 날짜</th>
								</tr>
								<%for(rankPeriodBean bean : rank_period_list){ %>
								<tr>
									<td>
										<input type="hidden" name="rank" value="<%=bean.getRank()%>"><%=bean.getRank() %>
									</td>
									<td>
										<input type="date" name="startDate" class="startDate" style="width:160px;" value="<%=bean.getStart() %>" max="9999-12-31">
									</td>
									<td>
										<input type="date" name="endDate" class="endDate" style="width:160px;" value="<%=bean.getEnd() %>" max="9999-12-31">
									</td>
								</tr>
								<%} %>
							</table>
						</div>

						<!-- /.container-fluid -->
						<div id="manager_btn">
							<input type="submit" value="저장" class="btn btn-primary">
						</div>
						</form>
						
					</div>
				</div>
			</div>
			<!-- End of Main Content -->
		</div>
		<!-- End of Content Wrapper -->
	</div>
	<!-- End of Page Wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>

	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">로그아웃 하시겠습니까?</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">확인버튼을 누를 시 로그아웃 됩니다.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">취소</button>
					<form method="post" action="../LogoutPro.jsp">
						<input type="submit" class="btn btn-primary" value="확인" />
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap core JavaScript-->
	<script src="../../vendor/jquery/jquery.min.js"></script>
	<script src="../../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="../../vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="../../js/sb-admin-2.min.js"></script>

	<!-- Page level plugins -->
	<script src="../../vendor/chart.js/Chart.min.js"></script>

	<!-- Page level custom scripts -->
	<script src="../../js/demo/chart-area-demo.js"></script>
	<script src="../../js/demo/chart-pie-demo.js"></script>
	<script src="../../js/demo/chart-bar-demo.js"></script>
</body>

</html>
