<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.io.PrintWriter"
	import="jsp.DB.method.*" import="jsp.Bean.model.*"
	import="java.util.ArrayList"
	%>
<!DOCTYPE html>
<html lang="en">

<head>

<%

	PrintWriter script =  response.getWriter();
	if (session.getAttribute("sessionID") == null){
		script.print("<script> alert('세션의 정보가 없습니다.'); location.href = '../login.jsp' </script>");
	}
	int permission = Integer.parseInt(session.getAttribute("permission").toString());
	if (permission > 1){
		script.print("<script> alert('관리자가 아닙니다.'); history.back(); </script>");
	}
	
	String sessionID = session.getAttribute("sessionID").toString();
	String sessionName = session.getAttribute("sessionName").toString();
	int year = Integer.parseInt(request.getParameter("date").split("-")[0]);
	
	ManagerDAO managerDao = new ManagerDAO();
	MSC_DAO  mscDao = new MSC_DAO();
	ArrayList<WorkPlaceBean> wpList = managerDao.getWorkPlaceList(year);
	
	request.setCharacterEncoding("UTF-8");
	int num = Integer.parseInt(request.getParameter("num"));
	MSC_Bean msc = mscDao.getMSCList_set(num);

	String setDate = msc.getDate();
	String setAm = msc.getAMplace();
	String setPm = msc.getPMplace();
%>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Sure FVMS - Manager_Schedule_Update</title>

<!-- Custom fonts for this template-->
<link href="../../vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet" type="text/css">
<link
	href="../../https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
	rel="stylesheet">

<!-- Custom styles for this template-->
<link href="../../css/sb-admin-2.min.css" rel="stylesheet">

</head>
<style>
.sidebar .nav-item{
	 	word-break: keep-all;
}
#sidebarToggle{
		display:none;
	}
.sidebar{
	position:relative;
	z-index:997;
}
#table_td {
	padding-left: 10px;
	padding-top: 10px;
	display: grid !important;
	padding-bottom: 10px;
}

details p {
	padding-left: 12px !important;
	margin: 3px 0px !important;
}

summary {
	border: 1px solid black;
	border-radius: 5px;
	padding: 6px;
}

.m-0.font-weight-bold.text-primary {
	display: inline-block;
	padding-left: 17px;
	vertical-align: middle;
}

#holiday_body {
	text-align: center;
	position: absolute;
	top: -36px;
	left: 50%;
	transform: translateX(-50%);
}

#Delete {
	float: right;
	width: 50px;
	height: 30px;
}

#Update {
	position: absolute;
	left: 42%;
	transform: translateX(-50%);
}

#cancel_btn {
	position: absolute;
	left: 45%;
	transform: translateX(-50%);
	margin-left: 55px;
}

#holiday {
	color: white;
	border: 0px solid;
	border-radius: 6px;
	height: 52px;
	font-weight: 700;
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

@media ( max-width :800px) {
	body{
		font-size:small;}
	#sidebarToggle{
		display:inline;
	}
	.card-header{
		margin-top:4.75rem;
	}
	.sidebar .nav-item{
	 	white-space:nowrap !important;
	 	font-size: x-large !important;	 	
	}
	.topbar{
		z-index:999;
		position:fixed;
		width:100%;
	}
	#accordionSidebar{
		width: 100%;
		height: 100%;
		text-align: center;
		display: inline;
		padding-top: 60px;
		position: fixed;
		z-index: 998;
	}
	#content{
		margin-left:0;
	}
	.nav-item{
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
	#Delete {
		margin-right: 15px;
	}
	body {
		font-size: small;
	}
}
</style>
<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
<script>

	 function AMfocus(){
	  document.getElementById('AMradio').checked=true;
	 }
	 function PMfocus(){
	  document.getElementById('PMradio').checked=true;
	 }
	 
	 
	<!-- 로딩화면 -->
	 window.onbeforeunload = function () { $('.loading').show(); }  //현재 페이지에서 다른 페이지로 넘어갈 때 표시해주는 기능
	 $(window).load(function () {          //페이지가 로드 되면 로딩 화면을 없애주는 것
	     $('.loading').hide();
	     placeSelected();
	     amtextbox();
	     pmtextbox();
	     amChangeSel();
	     pmChangeSel();
	 });

	 function amtextbox(){
			$("#amselboxDirect").hide();
			var se = document.getElementById("amPlaceSel");
			console.log(se.options[se.selectedIndex].value);
			if(se.options[se.selectedIndex].value == "기타"){
					$("#amselboxDirect").show();
			}else{
				$("#amselboxDirect").hide();
			}
			$("#amPlaceSel").change(function() {
					if($("#amPlaceSel").val() == "기타") {
						$("#amselboxDirect").show();
					}  else {
						$("#amselboxDirect").hide();
	 				}
		})
	 }
	 function pmtextbox(){
			var se = document.getElementById("pmPlaceSel");
			if(se.options[se.selectedIndex].value == "기타"){
				$("#pmselboxDirect").show();
			}else{
				$("#pmselboxDirect").hide();
			}
			$("#pmPlaceSel").change(function() {
					if($("#pmPlaceSel").val() == "기타") {
						$("#pmselboxDirect").show();
					}  else {
						$("#pmselboxDirect").hide();
					}
			})
	 }
	 
		function amChangeSel() {
			var se = document.getElementById("amPlaceSel");
			if(se.options[se.selectedIndex].value != "기타"){
				$("#amselboxDirect").val("");
			}
		}
		function pmChangeSel() {
			var se = document.getElementById("pmPlaceSel");
			if(se.options[se.selectedIndex].value != "기타"){
				$("#pmselboxDirect").val("");
			}
		}
		
		function placeSelected(){
			var opt = document.querySelectorAll("#amPlaceSel option");
			var opt2 = document.querySelectorAll("#pmPlaceSel option");
			$('#amPlaceSel').val("기타").attr('selected','selected');
			$('#pmPlaceSel').val("기타").attr('selected','selected');
			for(var a=0; a<opt.length; a++){
				if(opt[a].value == '<%=setAm%>'){
					$('#amPlaceSel option:eq('+a+')').attr('selected','selected');
					break;
				}
			}
			for(var b=0; b<opt2.length; b++){
				if(opt2[b].value == '<%=setPm%>'){
					$('#pmPlaceSel option:eq('+b+')').attr('selected','selected');
					break;
				}
			}
		}
</script>


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
				href="../expense_sum/expense_sum.jsp"> <i class="fas fa-fw fa-table"></i>
					<span>지출 요약</span></a></li>
					
			<!-- Nav Item - summary -->
			<li class="nav-item"><a class="nav-link"
				href="../profit_analysis/profit_analysis.jsp"> <i class="fas fa-fw fa-table"></i>
					<span>수익 지표</span></a></li>
					
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
			<li class="nav-item active"><a class="nav-link"
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
			<%if(permission == 0){ %>
			<li class="nav-item"><a class="nav-link"
				href="../manager/manager.jsp"> <i
					class="fas fa-fw fa-clipboard-list"></i> <span>관리자 페이지</span></a></li>
			<% }%>

			

		</ul>
		<!-- End of Sidebar -->

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<nav
					class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

					<!-- Sidebar Toggle (Topbar) -->
					<button id="sidebarToggleTop"
						class="btn btn-link d-md-none rounded-circle mr-3">
						<i class="fa fa-bars"></i>
					</button>

					<!-- Topbar Navbar -->
					<ul class="navbar-nav ml-auto">



						<div class="topbar-divider d-none d-sm-block"></div>

						<!-- Nav Item - User Information -->
						<li class="nav-item dropdown no-arrow"><a
							class="nav-link dropdown-toggle" href="#" id="userDropdown"
							role="button" data-toggle="dropdown" aria-haspopup="true"
							aria-expanded="false"> <span
								class="mr-2 d-none d-lg-inline text-gray-600 small"><%=sessionName%></span>
								<i class="fas fa-info-circle"></i>
						</a> <!-- Dropdown - User Information -->
							<div
								class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
								aria-labelledby="userDropdown">
								<a class="dropdown-item" href="#" data-toggle="modal"
									data-target="#logoutModal"> <i
									class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
									Logout
								</a>
							</div></li>

					</ul>

				</nav>
				<!-- End of Topbar -->

				<!-- Begin Page Content -->
				<div class="container-fluid">


					<div class="card shadow mb-4">
						<div class="card-header py-3">

							<h6 class="m-0 font-weight-bold text-primary"><%=sessionName%>
								일정수정
							</h6>
							<a id="Delete" href="manager_schedule_deletePro.jsp?num=<%=num%>"
								class="btn btn-secondary btn-icon-split"
								onclick="return confirm('삭제하시겠습니까?')">삭제</a>
						</div>
						<div class="card-body" style="margin-bottom: 52px;">
							<div class="table-responsive">


								<form method="post" action="manager_schedule_updatePro.jsp?"
									style="display: inline;">
									<table
										style="white-space: nowrap; overflow: hidden; width: 100%;">
										<tr>
											<td class="m-0 text-primary" align="center">날짜</td>
											<td style="padding: 15px 0;"><input type="date"
												name="DATE" style="width: 100%;" maxlength="50"
												value="<%=setDate%>"></td>
										</tr>
										<tr height="1" bgcolor="#fff">
											<td colspan="2"></td>
										</tr>
										<tr height="1" bgcolor="#82B5DF">
											<td colspan="2"></td>
										</tr>
										<tr>
											<td class="m-0 text-primary" align="center"
												style="white-space: nowrap;">오전장소</td>
											<td id="table_td">
											<select id="amPlaceSel" name="amPlaceSel" onchange="amChangeSel()">
												<%
													for(int i=0; i<wpList.size(); i++){%>
														<option class="test" value="<%=wpList.get(i).getPlace()%>"><%=wpList.get(i).getPlace()%></option>													
												<%}%>
													<option value="휴가">휴가</option>
													<option value="기타">기타</option>
											</select> <input type="text" id="amselboxDirect" name="amselboxDirect" value="<%=setAm%>"/></td>
										</tr>
										<tr height="1" bgcolor="#82B5DF">
											<td colspan="2"></td>
										</tr>
										<tr>
											<td class="m-0 text-primary" align="center"
												style="white-space: nowrap;">오후장소</td>
											<td id="table_td"><select id="pmPlaceSel"
												name="pmPlaceSel" onchange="pmChangeSel()">
													<%
														for(int i=0; i<wpList.size(); i++){%>
															<option class="test" value="<%=wpList.get(i).getPlace()%>"><%=wpList.get(i).getPlace()%></option>													
												<%}%>
													<option value="휴가">휴가</option>
													<option value="기타">기타</option>
											</select> <input type="text" id="pmselboxDirect" name="pmselboxDirect" value="<%=setPm%>"/></td>
										</tr>
										<tr height="1" bgcolor="#fff">
											<td colspan="2"></td>
										</tr>
									</table>

									<input type="hidden" name="num" value="<%=num%>"> <input
										id="Update" type="submit" name="COMPLETE" value="수정"
										class="btn btn-primary">

								</form>


								<a href="manager_schedule.jsp" class="btn btn-primary"
									id="cancel_btn">취소</a>
							</div>

						</div>
					</div>


					<!-- /.container-fluid -->

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

