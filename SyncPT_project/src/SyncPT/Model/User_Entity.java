package SyncPT.Model;

public class User_Entity {
	private String name; // 유저 이름
	private String w_sess; // 웹 소켓 세션 id
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getW_sess() {
		return w_sess;
	}
	public void setW_sess(String w_sess) {
		this.w_sess = w_sess;
	}	
}
