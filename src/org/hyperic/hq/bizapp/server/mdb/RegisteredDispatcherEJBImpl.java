/*
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 * 
 * Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
 * This file is part of HQ.
 * 
 * HQ is free software; you can redistribute it and/or modify
 * it under the terms version 2 of the GNU General Public License as
 * published by the Free Software Foundation. This program is distributed
 * in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA.
 */

package org.hyperic.hq.bizapp.server.mdb;

import java.util.Collection;
import java.util.Iterator;

import javax.ejb.EJBException;
import javax.ejb.MessageDrivenBean;
import javax.ejb.MessageDrivenContext;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.ObjectMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.events.AbstractEvent;
import org.hyperic.hq.events.ActionExecuteException;
import org.hyperic.hq.events.EventTypeException;
import org.hyperic.hq.events.TriggerInterface;
import org.hyperic.hq.events.ext.RegisteredTriggers;


/** The RegisteredDispatcher Message-Drive Bean registers Triggers and
 * dispatches events to them
 * <p>
 *
 * </p>
 * @ejb:bean name="RegisteredDispatcher"
 *      jndi-name="ejb/event/RegisteredDispatcher"
 *      local-jndi-name="LocalRegisteredDispatcher"
 *      transaction-type="Container"
 *      acknowledge-mode="Auto-acknowledge"
 *      destination-type="javax.jms.Topic"
 *
 * @jboss:destination-jndi-name name="topic/eventsTopic"
 *
 */

public class RegisteredDispatcherEJBImpl 
    implements MessageDrivenBean, MessageListener 
{
    private final Log log =
        LogFactory.getLog(RegisteredDispatcherEJBImpl.class);

    private void dispatchEvent(AbstractEvent event) {
        // Get interested triggers
        Collection triggers =
            RegisteredTriggers.getInterestedTriggers(event);
        
        //log.debug("There are " + triggers.size() + " registered for event");

        // Dispatch to each trigger
        for (Iterator i = triggers.iterator(); i.hasNext(); ) {
            TriggerInterface trigger = (TriggerInterface) i.next();
            try {
                trigger.processEvent(event);
            } catch (ActionExecuteException e) {
                // Log error
                log.error("ProcessEvent failed to execute action", e);
            } catch (EventTypeException e) {
                // The trigger was not meant to process this event
                log.debug("dispatchEvent dispatched to trigger (" +
                          trigger.getClass() + " that's not " +
                          "configured to handle this type of event: " +
                          event.getClass());
            }
        }
    }
    
    /**
     * The onMessage method
     */
    public void onMessage(Message inMessage) {
        if (!(inMessage instanceof ObjectMessage)) {
            return;
        }

        try {
            ObjectMessage om = (ObjectMessage) inMessage;
            Object obj = om.getObject();
            if (obj instanceof AbstractEvent) {
                AbstractEvent event = (AbstractEvent) obj;
                dispatchEvent(event);
            }
            else if (obj instanceof Collection) {
                Collection events = (Collection) obj;
                for (Iterator it = events.iterator(); it.hasNext(); ) {
                    AbstractEvent event = (AbstractEvent) it.next();
                    dispatchEvent(event);
                }
            }
        } catch (JMSException e) {
            log.error("Cannot open message object", e);
            e.printStackTrace();
        }
    }

    /**
     * @ejb:create-method
     */
    public void ejbCreate() {}
    public void ejbPostCreate() {}
    public void ejbActivate() {}
    public void ejbPassivate() {}

    /**
     * @ejb:remove-method
     */
    public void ejbRemove() {}

    public void setMessageDrivenContext(MessageDrivenContext ctx) {}
}
