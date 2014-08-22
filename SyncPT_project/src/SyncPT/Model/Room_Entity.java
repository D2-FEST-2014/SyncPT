package SyncPT.Model;

public class Room_Entity {
	private String access_code;
	private String room_name;
	private String host_name;
	private String file_name;
	private int media_type;
			
	public int getMedia_type() {
		return media_type;
	}
	public void setMedia_type(int media_type) {
		this.media_type = media_type;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getAccess_code() {
		return access_code;
	}
	public void setAccess_code(String access_code) {
		this.access_code = access_code;
	}
	public String getRoom_name() {
		return room_name;
	}
	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}
	public String getHost_name() {
		return host_name;
	}
	public void setHost_name(String host_name) {
		this.host_name = host_name;
	}
}
