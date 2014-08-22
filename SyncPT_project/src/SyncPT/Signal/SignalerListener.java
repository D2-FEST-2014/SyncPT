package SyncPT.Signal;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.vertx.java.core.impl.DefaultVertx;

/**
 * Application Lifecycle Listener implementation class SignalerListener
 *
 */
@WebListener
public class SignalerListener implements ServletContextListener {

    /**
     * Default constructor. 
     */
    public SignalerListener() {
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent contextEvent) {
    	ServletContext ctx = contextEvent.getServletContext();
    	Signaler signaler = new Signaler();
    	signaler.setVertx(new DefaultVertx());
    	signaler.setRealPath(ctx.getRealPath("uploadStorage"));
    	signaler.start();
    	ctx.setAttribute("sig_vert", signaler);
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0) {
    }
	
}
