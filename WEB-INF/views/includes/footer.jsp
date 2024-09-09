<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	</div>
        <!-- /#page-wrapper -->
    </div>
    <!-- /#wrapper -->
    <!-- jQuery 주석처리 -->
	<!-- <script src="/resources/vendor/jquery/jquery.min.js"></script> -->
    <!-- Bootstrap Core JavaScript -->
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>
    <!-- DataTables JavaScript -->
    <script src="/resources/vendor/datatables/js/jquery.dataTables.min.js"></script>
    <script src="/resources/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
    <script src="/resources/vendor/datatables-responsive/dataTables.responsive.js"></script>
    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>
    <!-- Page-Level Demo Scripts - Tables - Use for reference -->
    <script>
      $(document).ready(function() {
        $('#dataTables-example').DataTable({
          responsive: true
        });
        $(".sidebar-nav")
          .attr("class","sidebar-nav navbar-collapse collapse")
          .attr("aria-expanded",'false')
          .attr("style","height:1px");
      });
    </script>
    <div class="footer-wrapper">
        <div id="footer">
            <img src='/resources/img/newJeansLogo.png' alt="Logo">
            <div id="footer-info">
                주소 : 서울특별시 관악구 남부순환로 404길 7-19 성아빌딩 7층 | 대표번호 : 02) 0308-0308 | 인터넷신문등록번호 : 서울 아 0308 | 등록(발행)일자 : 1999.03.08 | 발행인 : 권성아 <br>
                &copy; 뉴眞스 All rights reserved. 무단 전재 및 재배포 금지
            </div>
        </div>
    </div>
</body>
</html>