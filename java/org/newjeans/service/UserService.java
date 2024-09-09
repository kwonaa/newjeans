package org.newjeans.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.sql.DataSource;

import org.newjeans.domain.AuthDTO;
import org.newjeans.domain.SignUpDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
	// 채은열 0828
	// 추가*******************************************************************************************************************
	@Autowired
	private DataSource dataSource;

	private final BCryptPasswordEncoder passwordEncoder;

	public UserService() {
		this.passwordEncoder = new BCryptPasswordEncoder();
	}

	public void saveUser(SignUpDTO signUpDTO) {
		String encodedPassword = passwordEncoder.encode(signUpDTO.getUserpw());
		Date now = new Date(System.currentTimeMillis());

		String usersql = "INSERT INTO tbl_member (userid, userpw, userName, regDate, updateDate, enabled) VALUES (?, ?, ?, ?, ?, ?)";
		String authSql = "INSERT INTO tbl_member_auth (userid, auth) VALUES (?, ?)";
		try (Connection connection = dataSource.getConnection();
				PreparedStatement stmt = connection.prepareStatement(usersql);
				PreparedStatement astmt = connection.prepareStatement(authSql)) {

			stmt.setString(1, signUpDTO.getUserid());
			stmt.setString(2, encodedPassword);
			stmt.setString(3, signUpDTO.getUserName());
			stmt.setDate(4, new java.sql.Date(now.getTime()));
			stmt.setDate(5, new java.sql.Date(now.getTime()));
			stmt.setBoolean(6, signUpDTO.isEnabled());

			stmt.executeUpdate();

			// 권한 정보 저장
			if (signUpDTO.getAuthList() != null) {
				for (AuthDTO authDTO : signUpDTO.getAuthList()) {
					astmt.setString(1, authDTO.getUserid());
					astmt.setString(2, authDTO.getAuth());
					astmt.addBatch(); // 배치 처리
				}
				astmt.executeBatch(); // 배치 실행
			}

		} catch (SQLException e) {
			e.printStackTrace(); // 로그를 찍거나 예외 처리를 추가
		}
	}

	public boolean isUserIdAvailable(String userid) {
		String sql = "SELECT COUNT(*) FROM tbl_member WHERE userid = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement psmt = conn.prepareStatement(sql)) {

			psmt.setString(1, userid);
			ResultSet rs = psmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) == 0;
			}

		} catch (SQLException e) {
			e.printStackTrace(); // 로그를 찍거나 예외 처리를 추가
		}

		return false;
	}

	public int userCheck(String userid, String userpw) {
		int result = -1;

		String sql = "SELECT userpw FROM tbl_member WHERE userid = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement psmt = conn.prepareStatement(sql)) {
			psmt.setString(1, userid);
			try (ResultSet rs = psmt.executeQuery()) {
				if (rs.next()) {
					String encodedPassword = rs.getString("userpw");
					if (encodedPassword != null && passwordEncoder.matches(userpw, encodedPassword)) {
						result = 1; // 비밀번호 일치하는 경우
					} else {
						result = 0; // 비밀번호 일치하지 않는 경우
					}
				} else {
					result = -1; // id가 존재하지 않는 경우
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 0902 채은열
	// 추가*****************************************************************************************************
	public int passCheck(String userid, String userpw) {// 회원정보 수정 페이지 진입 전 비밀번호 확인

		int result = -1;

		String sql = "SELECT userpw FROM tbl_member WHERE userid = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement psmt = conn.prepareStatement(sql)) {
			psmt.setString(1, userid);
			try (ResultSet rs = psmt.executeQuery()) {
				if (rs.next()) {
					String encodedPassword = rs.getString("userpw");
					if (encodedPassword != null && passwordEncoder.matches(userpw, encodedPassword)) {
						result = 1; // 비밀번호 일치하는 경우
					} else {
						result = 0; // 비밀번호 일치하지 않는 경우
					}
				} else {
					result = -1; // id가 존재하지 않는 경우
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public SignUpDTO memberInfo(String userid) throws SQLException {// 비밀번호확인 전 회원정보확인

		SignUpDTO user = null;

		String sql = "SELECT userid,username,email,pnumber,address FROM tbl_member WHERE userid = ?";

		 try (Connection conn = dataSource.getConnection(); 
		         PreparedStatement psmt = conn.prepareStatement(sql)) {
		        psmt.setString(1, userid);
		        try (ResultSet rs = psmt.executeQuery()) {
		            if (rs.next()) {
		                user = new SignUpDTO();
		                user.setUserid(rs.getString("userid"));
		                user.setUserName(rs.getString("username"));
		                user.setEmail(rs.getString("email"));
		                user.setPnumber(rs.getString("pnumber"));
		                user.setAddress(rs.getString("address"));
		            }
		        }
		 }
		 return user;
	}


	public void updateUser(SignUpDTO signUpDTO) { // 회원정보수정
		String encodedPassword = passwordEncoder.encode(signUpDTO.getUserpw());
		Date now = new Date(System.currentTimeMillis());

		String usersql = "UPDATE tbl_member SET userpw = ?, userName = ?, updateDate = ?, email = ?, pnumber = ?, address = ? WHERE userid = ?";

		try (Connection connection = dataSource.getConnection();
				PreparedStatement stmt = connection.prepareStatement(usersql)) {

			stmt.setString(1, encodedPassword);
			stmt.setString(2, signUpDTO.getUserName());
			stmt.setDate(3, new java.sql.Date(now.getTime()));
			stmt.setString(4, signUpDTO.getEmail());
			stmt.setString(5, signUpDTO.getPnumber());
			stmt.setString(6, signUpDTO.getAddress());
			stmt.setString(7, signUpDTO.getUserid());

			stmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace(); // 로그를 찍거나 예외 처리를 추가
		}

	}

}
// 0902 채은열
// 추가*****************************************************************************************************
