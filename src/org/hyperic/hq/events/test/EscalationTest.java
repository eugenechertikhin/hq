package org.hyperic.hq.events.test;

import org.hyperic.hq.test.HQEJBTestBase;
import org.hyperic.hq.events.server.session.Escalation;
import org.hyperic.hq.events.server.session.EscalationAction;
import org.hyperic.hq.events.server.session.EscalationState;
import org.hyperic.hq.events.server.session.Action;
import org.hyperic.hq.events.EscalationMediator;
import org.hyperic.hq.bizapp.shared.action.EmailActionConfig;
import org.hyperic.hq.authz.shared.PermissionException;
import org.hibernate.ObjectNotFoundException;

import javax.naming.NamingException;
import javax.ejb.EJBException;
import java.util.HashSet;
import java.util.Random;

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

public class EscalationTest
    extends HQEJBTestBase {
    private final String BOGUS_NAME1 =
        "bogus1 " + (new Random()).nextInt(10000);
    private final String BOGUS_NAME2 =
        "bogus2 " + (new Random()).nextInt(10000);
    private final Integer ALERT_DEF_ID1 = new Integer(10001);
    private final Integer ALERT_DEF_ID2 = new Integer(10002);

    public EscalationTest(String testName) {
        super(testName);
    }

    public void testCreateEscalation() throws Exception {

        runInTransaction(new TransactionBlock() {
            public void run() throws Exception {
                createEscalationTest();
                resetEscalationActiveStatusTest();
            }
        });

    }

    private void createEscalationTest()
        throws javax.ejb.CreateException, NamingException, PermissionException
    {
        EscalationAction act1 = createEmailAction(
            new String[] {"joe@gmail.com", "bob@yahoo.com"});

        EscalationAction act2 = createEmailAction(
            new String[] {"paul@att.com", "bill@google.com"});

        EscalationAction act3 = createSyslogAction("meta", "tomcat", "5.0");

        Escalation e = Escalation.newInstance(BOGUS_NAME1);
        e.getActions().add(act1);
        e.getActions().add(act2);
        e.getActions().add(act3);

        EscalationMediator.getInstance().save(e);
        // look it up, there should be exactly one
        e = EscalationMediator.getInstance().findEscalationById(e);
        assertNotNull(e);
        assertTrue(e.getActions().size() == 3);
        
        // verify escalation order
        Action a1 = ((EscalationAction)e.getActions().get(0)).getAction();
        Action a2 = ((EscalationAction)e.getActions().get(1)).getAction();
        Action a3 = ((EscalationAction)e.getActions().get(2)).getAction();
        assertTrue(a1.getId().equals(act1.getAction().getId()));
        assertTrue(a2.getId().equals(act2.getAction().getId()));
        assertTrue(a3.getId().equals(act3.getAction().getId()));

        // alter escalation order
        e.getActions().clear();
        e.getActions().add(act2);
        e.getActions().add(act3);
        e.getActions().add(act1);

        EscalationMediator.getInstance().save(e);
        // look it up, there should be exactly one
        e = EscalationMediator.getInstance().findEscalationById(e);
        assertNotNull(e);
        // should still have 2 actions
        assertTrue(e.getActions().size() == 3);

        // verify escalation order
        a1 = ((EscalationAction)e.getActions().get(0)).getAction();
        a2 = ((EscalationAction)e.getActions().get(1)).getAction();
        a3 = ((EscalationAction)e.getActions().get(2)).getAction();
        assertTrue(a1.getId().equals(act2.getAction().getId()));
        assertTrue(a2.getId().equals(act3.getAction().getId()));
        assertTrue(a3.getId().equals(act1.getAction().getId()));

        EscalationState state =
            EscalationMediator.getInstance().getEscalationState(e, ALERT_DEF_ID1);
        long mtime = state.getModifiedTime();
        EscalationMediator.getInstance().save(state);
       // escalation state time should not be updated
        state =
            EscalationMediator.getInstance().getEscalationState(e, ALERT_DEF_ID1);
        assertTrue(state.getModifiedTime() == mtime);

        // update state
        mtime = state.getModifiedTime();
        state.setCurrentLevel(1);
        EscalationMediator.getInstance().save(state);
        // escalation state time should have been  updated
        state =
            EscalationMediator.getInstance().getEscalationState(e, ALERT_DEF_ID1);
        assertTrue(state.getModifiedTime() > mtime);
        
        EscalationMediator.getInstance().remove(e);
        try {
            EscalationMediator.getInstance().findEscalationById(e);
            assertTrue(1==0);
        } catch (EJBException ignore) {
            // object should not be found
            Exception ex = ignore.getCausedByException();
            assertTrue(ex instanceof ObjectNotFoundException);
        } catch (ObjectNotFoundException ignore) {
            // object should not be found
        }
    }

    private EscalationAction createEmailAction(String[] users) {
        HashSet u = new HashSet();
        for (int i=0; i<users.length; i++) {
            u.add(users[i]);
        }
        return EscalationAction.newEmailAction(
            EmailActionConfig.TYPE_EMAILS, u, 60000);
    }

    private EscalationAction createSyslogAction(String metaProject, String proj,
                                                String version)
    {
        return EscalationAction.newSyslogAction(metaProject, proj, version,
            60000);
    }

    private void resetEscalationActiveStatusTest() throws PermissionException
    {
        EscalationAction act1 = createEmailAction(
            new String[] {"joe1@gmail.com", "bob1@yahoo.com"});

        EscalationAction act2 = createEmailAction(
            new String[] {"paul1@att.com", "bill1@google.com"});

        Escalation e = Escalation.newInstance(BOGUS_NAME2);
        e.getActions().add(act1);
        e.getActions().add(act2);

        EscalationMediator.getInstance().save(e);
        e = EscalationMediator.getInstance().findEscalationById(e);
        // verify number of actions
        assertTrue(e.getActions().size() == 2);

        // set state to active
        EscalationState state1 =
            EscalationMediator.getInstance().getEscalationState(e, ALERT_DEF_ID2);
        state1.setActive(true);
        e.setAllowPause(true);
        EscalationMediator.getInstance().save(e);
        EscalationMediator.getInstance().save(state1);
        state1 =
            EscalationMediator.getInstance().getEscalationState(e, ALERT_DEF_ID2);

        // verify active status has been set
        assertTrue(state1.isActive());
        assertTrue(e.isAllowPause());

        // clear active status
        EscalationMediator.getInstance()
            .clearActiveEscalation(e.getId(), ALERT_DEF_ID2);

        state1 =
            EscalationMediator.getInstance()
                .getEscalationState(e, ALERT_DEF_ID2);
        // verify active status has been cleared
        assertTrue(!state1.isActive());

        EscalationMediator.getInstance().remove(e);
        try {
            EscalationMediator.getInstance().findEscalationById(e);
            assertTrue(1==0);
        } catch (EJBException ignore) {
            // object should not be found
            Exception ex = ignore.getCausedByException();
            assertTrue(ex instanceof ObjectNotFoundException);
        } catch (ObjectNotFoundException ignore) {
            // object should not be found
        }
    }

}
