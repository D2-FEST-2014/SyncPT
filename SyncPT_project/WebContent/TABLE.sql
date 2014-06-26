CREATE TABLE user_list (
	u_id VARCHAR(10) NOT NULL PRIMARY KEY,
	u_name VARCHAR(255) NOT NULL,
	jsession_id VARCHAR(255),
	wsession_id VARCHAR(255)	
);

INSERT INTO user_list VALUES ('0','0','0','0');


ALTER TABLE room_list drop column slide_num;

CREATE TABLE room_list (
	access_code VARCHAR(7) NOT NULL PRIMARY KEY,
	host_id VARCHAR(10) NOT NULL DEFAULT '0',
	FOREIGN KEY(host_id) REFERENCES user_list(u_id)
);

CREATE TABLE access_list (
	u_access VARCHAR(30) NOT NULL,
	u_id VARCHAR(10) NOT NULL,
	access_code VARCHAR(7) NOT NULL,
	FOREIGN KEY(u_id) REFERENCES user_list(u_id),
	FOREIGN KEY(access_code) REFERENCES room_list(access_code),
	PRIMARY KEY(u_id,access_code)
);

CREATE TABLE file_list (
	f_index INT NOT NULL AUTO_INCREMENT,
	access_code VARCHAR(7) NOT NULL,
	file_name VARCHAR(255) NOT NULL,
	slide_count INT NOT NULL,
	PRIMARY KEY(f_index),
	FOREIGN KEY(access_code) REFERENCES room_list(access_code)
);

