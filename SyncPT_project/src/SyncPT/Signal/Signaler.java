package SyncPT.Signal;

import java.io.File;
import java.util.ArrayList;

import org.vertx.java.core.Handler;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.json.JsonArray;
import org.vertx.java.core.json.JsonObject;
import org.vertx.java.platform.Verticle;

import SyncPT.Model.DBofSyncPT;
import SyncPT.Model.User_Entity;

import com.nhncorp.mods.socket.io.SocketIOServer;
import com.nhncorp.mods.socket.io.SocketIOSocket;
import com.nhncorp.mods.socket.io.impl.DefaultSocketIOServer;

public class Signaler extends Verticle {
	private SocketIOServer io = null;
	private int port;
	private String realPath;
	//private HashMap<String, String> initMap = new HashMap<String, String>(); 
	private DBofSyncPT db = new DBofSyncPT();
	
	public void start() {
		port = 8080;
		HttpServer server = vertx.createHttpServer();
		
		io = new DefaultSocketIOServer(vertx, server);
		io.sockets().onConnection(new Handler<SocketIOSocket>() {
			public void handle(final SocketIOSocket socket) {
				socket.on("message", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("roomid");
						event.removeField("roomid");
						socket.broadcast().to(roomid).emit("message", event);
					}
				});
				socket.on("create", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");
						int rtcMax = event.getInteger("rtcMax");
						int isOpen = Integer.parseInt(event.getString("isOpen"));
						
						if (db.setRtcMax(roomid, rtcMax, isOpen)) {
							System.out.println("RTC준비 완료");
						}						
					}
				});
				socket.on("trysignal", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");
						String host = db.get_Host(roomid);
						int successLv;
						
						event.putString("to", host);

						// rtc접속 인원 관리
						successLv = db.upRtcNow(roomid);
						if (successLv != 0) socket.broadcast().to(roomid).emit("message", event);
						
						if (successLv == 0) {
							event.putBoolean("result", false);
							event.putBoolean("available", false);
						} else if (successLv == 1) {
							event.putBoolean("result", true);
							event.putBoolean("available", false);
						} else {
							event.putBoolean("result", true);
							event.putBoolean("available", true);
						}
						
						event.removeField("to");
						event.removeField("participationRequest");
						io.sockets().in(roomid).emit("signalFlag", event); //방안에 나포함 전체한테 보내는거
					}
				});
				socket.on("leave", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");
						boolean available = false; // 
						String userid = event.getString("userid");
						String host = db.get_Host(roomid); // 방장 u_id

						event.removeField("to");
						
						if(host.equals(userid)) { // 방장이 나간 경우(데이터베이스를 다 지워주고, 서버에서 폴더와 파일 삭제, 참여자들은 첫 페이지로 이동 
							ArrayList<User_Entity> list = db.get_User(roomid);
							db.del_Access_All(roomid);
							db.del_Files(roomid);
							db.del_Room(roomid);
										
							for(int i=0; i<list.size(); i++) {
								db.del_User(list.get(i).getU_id()); // user_list 테이블에서 유저 삭제	
							}											
							event.putBoolean("maintain", false); // 방 유지 여부(false면 방 아웃)
							
							String uploadPath = realPath + "\\" + roomid;
							File tempDir = new File(uploadPath);
							String[] files = tempDir.list();

							if(files!=null) {
								for(int i=0; i<files.length; i++) {
									File f = new File(tempDir,files[i]);
									f.delete(); 
								}
							}

							tempDir.delete();
						}
						else { // 참여자가 나간 경우, 자신의 정보를 회의방 사람들에게 알려줌. 
							db.leave_room(userid); // access_list 테이블에서 유저 삭제
							db.del_User(userid); // user_list 테이블에서 유저 삭제

							// rtc접속 인원 관리
							if (event.getBoolean("rtc")) {
								available = db.downRtcNow(roomid);
							}
							
							//event.putString("host", host);
							event.putBoolean("maintain", true);
						}

						// 2. 참여자가 나간 경우 먼저 access_list 테이블에서 참여자 정보 삭제하기.

						event.putBoolean("available", available);
						socket.broadcast().to(roomid).emit("message", event); // 나를 제외한 나머지에게, 새로 들어온 정보만
						socket.leave(roomid);
					}
				});

				// 회의방 입장
				socket.on("enter_room", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						JsonObject message = new JsonObject();
						
						String roomid = event.getString("to");
						String userid = event.getString("userid");
						String host = db.get_Host(roomid);
						
						JsonArray users = new JsonArray(); // 참여자 목록을 담기위한 JSONArray
						event = new JsonObject();
						
						ArrayList<User_Entity> list = db.get_User(roomid);
						
						for(int i=0; i<list.size(); i++) {
							
							if(list.get(i).getU_id().equals(host)) { 
								event.putString("hostname", list.get(i).getName()); // 방장 이름
								event.putString("host", host); // 방장 아이디 
							}
							
							if(list.get(i).getU_id().equals(userid)) {
								event.putString("username", list.get(i).getName()); // 자기 자신 이름
								event.putString("userid", userid); // 자기 자신 아이디 
								message.putString("user_name", list.get(i).getName());
								message.putString("userid", userid);
							}

							else {
								JsonObject user = new JsonObject();
								user.putString("user_name", list.get(i).getName());
								user.putString("user_id", list.get(i).getU_id());

								users.add(user);
							}
						}
						
						event.putArray("user_list", users);
						
						socket.join(roomid);
						socket.broadcast().to(roomid).emit("enter", message); // 나를 제외한 나머지에게, 새로 들어온 정보만
						socket.emit("enter", event);
					}
				});
				
				// 슬라이드 페이지 관리
				socket.on("slide_control", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");						
						socket.broadcast().to(roomid).emit("page_control", event);
					}
				});

				// 선택한 파일 변경
				socket.on("selectfile", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드
						String file = event.getString("file"); // 파일 이름

						event.removeField("to");
						int slide_count = db.get_SlideNum(roomid, file);

						event.putNumber("count", slide_count);

						socket.emit("select_file", event);
					}
				});
				
				// 슬라이드쇼 시작 / 종료
				socket.on("slide_show", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드
						String file = event.getString("file"); // 파일 이름
						boolean show = event.getBoolean("show");
						System.out.println("show : " + show);
						event.removeField("show");
						// 슬라이드쇼 시작
						if(show) {							
							int count = db.get_SlideNum(roomid, file);
							event.putNumber("count", count);
							socket.broadcast().to(roomid).emit("show_start", event);
						}
						// 슬라이드쇼 종료
						else {
							io.sockets().in(roomid).emit("show_stop", event); //방안에 나포함 전체한테 보내는거
						}	
					}
				});
				
				// 채팅
				socket.on("chat", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");
						event.removeField("to");
						socket.broadcast().to(roomid).emit("chat", event);
					}
				});
				
				// 포인터 동기화
		        socket.on("syncPoint", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to");
						event.removeField("to");
						
						socket.broadcast().to(roomid).emit("syncPoint", event);
					}
				});
		        
				// 권한 요청
		        socket.on("c_request", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드

						event.removeField("to");						
						socket.broadcast().to(roomid).emit("c_request", event);	
					}
				});

				// 수락
				socket.on("c_accept", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드
						
						event.removeField("to");
						socket.broadcast().to(roomid).emit("c_accept", event);
					}
				});

				// 권한 요청 중지
				socket.on("request_stop", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드
						
						event.removeField("to");
						io.sockets().in(roomid).emit("request_stop", event); //방안에 나포함 전체한테 보내는거				
					}
				});

				// 권한 요청 중지
				socket.on("request_cancel", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드

						event.removeField("to");
						io.sockets().in(roomid).emit("request_cancel", event);
					}
				});
				
				// 권한 거절하기
				socket.on("refuse", new Handler<JsonObject>() {
					public void handle(JsonObject event) {
						String roomid = event.getString("to"); // 엑세스 코드

						event.removeField("to");
						socket.broadcast().to(roomid).emit("refuse", event);						
					}
				});
				
				// 방 초기화 정보
	            socket.on("tryRoomInfo", new Handler<JsonObject>() {
	               public void handle(JsonObject event) {
	                  String roomid = event.getString("to"); // 엑세스 코드
	                  event.removeField("to");

	                  socket.broadcast().to(roomid).emit("tryRoomInfo", event);
	               }
	            });
			}
		});
		
		server.listen(port);
	}
	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}
}
