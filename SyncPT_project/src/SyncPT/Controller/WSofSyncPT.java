package SyncPT.Controller;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.catalina.connector.Request;
import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WebSocketServlet;

import SyncPT.Model.UserStream;

public class WSofSyncPT extends  WebSocketServlet {
	private static final long serialVersionUID = 1L;

	// for new clients, <sessionId, streamInBound>
	private static ConcurrentHashMap<String, StreamInbound> clients = new ConcurrentHashMap<String, StreamInbound>();

	protected StreamInbound createWebSocketInbound(String protocol,HttpServletRequest httpServletRequest) {

		// Check if exists
		HttpSession session = httpServletRequest.getSession();
		// find client  
		StreamInbound client = clients.get(session.getId());

		System.out.println("웹소켓 세션 아이디 : " + session.getId());
		
		String path = httpServletRequest.getServletContext().getRealPath("uploadStorage");
		System.out.println("경로 : " + path );
				
		if (null != client) {
			System.out.println("있음!");
			Set<String> ks = clients.keySet();
			System.out.println("1 : " + ks.size());
			return client;
		} else {
			System.out.println("새로!");
			client = new UserStream(httpServletRequest, clients);
			clients.put(session.getId(), client);
		}
		Set<String> ks = clients.keySet();
		System.out.println("2 : " + ks.size());
		return client;
	}

	public StreamInbound getClient(String sessionId) {
		System.out.println("getClient");
		return clients.get(sessionId);
	}

	public void addClient(String sessionId, StreamInbound streamInBound) {
		System.out.println("addClient");	 
		//clients.put(sessionId, streamInBound);
	}


}
