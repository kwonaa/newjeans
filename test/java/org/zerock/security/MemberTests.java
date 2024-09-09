package org.zerock.security;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/security-context.xml" })
@Log4j
public class MemberTests {

	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	@Setter(onMethod_ = @Autowired)
	private DataSource ds;

//	@Test
//	public void testInsertMember() {
//
//		// 멤버 테이블 insert
//		String sql = "insert into tbl_member(userid, userpw, username) values (?,?,?)";
//
//		for (int i = 0; i < 100; i++) { // 100명 만들기
//
//			Connection con = null;
//			PreparedStatement pstmt = null;
//
//			try {
//				con = ds.getConnection();
//				pstmt = con.prepareStatement(sql);
//
//				// 비밀번호 암호화
//				pstmt.setString(2, pwencoder.encode("pw" + i)); // pwencoder의 encode 함수로 암호화 처리. 사용자가 입력한 비밀번호가 "pw"에
//																// 들어옴
//
//				if (i < 80) { // 0번부터 79번까지 80명은 일반사용자
//
//					pstmt.setString(1, "user" + i);
//					pstmt.setString(3, "일반사용자" + i);
//
//				} else if (i < 90) { // 80번부터 89번까지는 운영자
//
//					pstmt.setString(1, "manager" + i);
//					pstmt.setString(3, "운영자" + i);
//
//				} else { // 90번부터 99번까지는 관리자
//
//					pstmt.setString(1, "admin" + i);
//					pstmt.setString(3, "관리자" + i);
//
//				}
//
//				pstmt.executeUpdate();
//
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				if (pstmt != null) {
//					try {
//						pstmt.close();
//					} catch (Exception e) {
//					}
//				}
//				if (con != null) {
//					try {
//						con.close();
//					} catch (Exception e) {
//					}
//				}
//
//			}
//		} // end for
//	}
	
	@Test
	public void testInsertAuth() {

		// 권한 테이블 insert
		String sql = "insert into tbl_member_auth (userid, auth) values (?,?)";

		for (int i = 0; i < 100; i++) {

			Connection con = null;
			PreparedStatement pstmt = null;

			try {
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql);

				if (i < 80) {

					pstmt.setString(1, "user" + i);
					pstmt.setString(2, "ROLE_USER");

				} else if (i < 90) {

					pstmt.setString(1, "manager" + i);
					pstmt.setString(2, "ROLE_MEMBER");

				} else {

					pstmt.setString(1, "admin" + i);
					pstmt.setString(2, "ROLE_ADMIN");

				}

				pstmt.executeUpdate();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (pstmt != null) {
					try {
						pstmt.close();
					} catch (Exception e) {
					}
				}
				if (con != null) {
					try {
						con.close();
					} catch (Exception e) {
					}
				}

			}
		} // end for
	}

}
