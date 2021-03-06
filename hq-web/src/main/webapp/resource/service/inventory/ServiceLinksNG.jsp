<%@ page language="java" %>
<%@ page errorPage="/common/Error2.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>

<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004-2009], Hyperic, Inc.
  This file is part of HQ.
  
  HQ is free software; you can redistribute it and/or modify
  it under the terms version 2 of the GNU General Public License as
  published by the Free Software Foundation. This program is distributed
  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE. See the GNU General Public License for more
  details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA.
 --%>


<tiles:importAttribute name="resource" ignore="true"/>
<c:if test="${not empty resource}">
 <hq:userResourcePermissions debug="false" resource="${Resource}"/>
  <table border="0"><tr><td class="LinkBox">
    <c:if test="${canModify}">
    	<s:a action="editConfigInventoryServiceVisibility.action">
    		<s:param name="mode" value="editConfig"/>
    		<s:param name="eid" value="%{#attr.Resource.entityId}"/>
			<s:param name="rid" value="%{#attr.Resource.entityId.id}"/>
			<s:param name="type" value="%{#attr.Resource.entityId.type}"/>
    		<fmt:message key="resource.service.inventory.link.Configure"/>
    		<img src='<s:url value="/images/title_arrow.gif"/>' width="11" height="9" alt="" border="0"/>
    	</s:a><br />
	</c:if>
    <c:if test="${canRemove}" >
    	<tiles:insertDefinition name=".resource.common.quickDelete">
      		<tiles:putAttribute name="resource" value="${resource}"/>
	  		<tiles:putAttribute name="deleteMessage">
				<fmt:message key="resource.service.inventory.link.DeleteService"/>
	  		</tiles:putAttribute>
    	</tiles:insertDefinition>
	<br />
	</c:if>
    <tiles:insertDefinition name=".resource.common.quickFavorites">
      <tiles:putAttribute name="resource" value="${resource}"/>
    </tiles:insertDefinition>
	<br />
	<s:a href="#" name="AddToGroupMenuLink"><fmt:message key="resource.group.AddToGroup.Title"/><img src='<s:url value="/images/title_arrow.gif"/>' width="11" height="9" alt="" border="0"/></s:a>
</td></tr></table>

<tiles:insertDefinition name=".resource.common.addToGroup">
	<tiles:putAttribute name="resource" value="${resource}"/>
</tiles:insertDefinition>

</c:if>
