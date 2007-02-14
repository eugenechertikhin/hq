<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="struts-html-el" prefix="html"%>
<%@ taglib uri="struts-tiles" prefix="tiles"%>
<%@ taglib uri="jstl-fmt" prefix="fmt"%>
<%@ taglib uri="display" prefix="display"%>
<%@ taglib uri="jstl-c" prefix="c"%>

<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".

  Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
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
<script language="JavaScript" src='<html:rewrite page="/js/scriptaculous.js"/>'
  type="text/javascript"></script>
<script src='<html:rewrite page="/js/dashboard.js"/>' type="text/javascript"></script>
<script src='<html:rewrite page="/js/effects.js"/>' type="text/javascript"></script>
<script src='<html:rewrite page="/js/popup.js"/>' type="text/javascript"></script>
<script type="text/javascript">
 onloads.push(requestViewEscalation);

 function requestViewEscalation() {
        var alertDefId = $('alertDefId').value;
        var url = '<html:rewrite page="/escalation/jsonByEscalationId/"/>';
        url += escape('<c:out value="${param.escId}"/>');
        url += '.do';
        new Ajax.Request(url, {method: 'get', onSuccess:showViewEscResponse, onFailure :reportError});
        }


function showViewEscResponse(originalRequest) {
    var tmp = eval('(' + originalRequest.responseText + ')');
    var creationTime = tmp.escalation.creationTime;
    var notifyAll = tmp.escalation.notifyAll;
    var _version_ = tmp.escalation._version_;
    var modifiedTime = tmp.escalation.modifiedTime;
    var actions = tmp.escalation.actions;
    var allowPause = tmp.escalation.allowPause;
    var escName = tmp.escalation.name;
    var description = tmp.escalation.description;
    var id = tmp.escalation.id;
    var maxWaitTime = (tmp.escalation.maxWaitTime / 60000) +
       " <fmt:message key="alert.config.props.CB.Enable.TimeUnit.1"/>";
     
    $('viewEscalation').style.display = "";
  
    $('escId').value = id;
    $('id').value = id;

    $('name').innerHTML = '<b>' + escName + '</b>';
    $('escName').value = escName;

    $('description').innerHTML = description + "&nbsp;";
    if (description) {
        $('escDesc').value = description;
    }

    if (allowPause) {
        $('acknowledged').innerHTML = '<fmt:message key="alert.config.escalation.allow.pause" /> ' + maxWaitTime;
        $('allowPauseTrue').checked = "true";
    }
    else {
        $('acknowledged').innerHTML = '<fmt:message key="alert.config.escalation.allow.continue" />';
        $('allowPauseFalse').checked = "true";
    }

    if (notifyAll) {
        $('changed').innerHTML = '<fmt:message key="alert.config.escalation.state.change.notify.all" />';
        $('notifyAllFalse').checked = "true";
    }
    else {
        $('changed').innerHTML = '<fmt:message key="alert.config.escalation.state.change.notify.previous" />';
        $('notifyAllTrue').checked = "true";
    }

    var escViewUL = $('viewEscalationUL');

    for (var i = escViewUL.childNodes.length - 1; i > -1; i--) {
        escViewUL.removeChild(escViewUL.childNodes[i]);
    }

    if (actions.length == 0) {
        $('noActions').style.display = "";
    }
    else {
        $('viewSection').style.display = "";
    }

    for (i = 0; i < actions.length; i++) {
      var actionConfig = actions[i].action.config;
      var configListType = actionConfig.listType;
      var configNames = actionConfig.names;
      var configSms = actionConfig.sms;
      var configMeta = actionConfig.meta;
      var configVersion = actionConfig.version;
      var configProduct = actionConfig.product;
      var actionId = actions[i].action.id;
      var actionsClassName = actions[i].action.className;
      var actionsVersion = actions[i].action._version_;
      var actionWaitTime = (actions[i].waitTime / 60000) +
         " <fmt:message key="alert.config.props.CB.Enable.TimeUnit.1"/>";

      var liID = actionId;
      var viewLi = document.createElement('li');
      var remDiv = document.createElement('div');
      var usersDiv = document.createElement('div');
      var usersTextDiv = document.createElement('div');
      var usersEditDiv = document.createElement('div');
      var rolesDiv = document.createElement('div');
      var othersDiv = document.createElement('div');
      var waitDiv = document.createElement('div');
      var editWaitDiv = document.createElement('div');
      var sysDiv = document.createElement('div');
      var escTable = document.createElement('table');
      var escTableBody = document.createElement('tbody');
      var escTr1 = document.createElement('tr');
      var escTr2 = document.createElement('tr');
      var escTrHeader = document.createElement('tr');
      var td1 = document.createElement('td');
      var td2 = document.createElement('td');
      var td3 = document.createElement('td');
      var td4 = document.createElement('td');
      var td5 = document.createElement('td');
      var td6 = document.createElement('td');
      var td7 = document.createElement('td');
      var td8 = document.createElement('td');
      var select1 = document.createElement("select");
      var select2 = document.createElement("select");
      var select3 = document.createElement("select");
      var anchor = document.createElement("a");
  
      var emailInfo = actionConfig.names;

      $('creationTime').value = creationTime;
      $('notifyAll').value = notifyAll;
      $('_version_').value = _version_;
      $('modifiedTime').value = modifiedTime;
      $('allowPause').value = allowPause;
      $('id').value = id;
  
      escViewUL.appendChild(viewLi)
  
      viewLi.setAttribute((document.all ? 'className' : 'class'), "BlockContent");
      viewLi.setAttribute('id','row_'+ liID);
      $('row_'+ liID).style.margin = "0px";
      $('row_'+ liID).style.padding = "0px";
      
      viewLi.appendChild(escTable);
      escTable.setAttribute((document.all ? 'className' : 'class'), "escTbl");
      escTable.setAttribute('id','escTbl_'+ liID);
      escTable.setAttribute('border', '0');
      escTable.setAttribute('cellpadding','2');

      escTable.appendChild(escTableBody);
      escTableBody.appendChild(escTrHeader);
      escTableBody.appendChild(escTr2);
      escTableBody.appendChild(escTr1);


     escTrHeader.appendChild(td6);
      td6.setAttribute('colSpan', '3');
      td6.setAttribute((document.all ? 'className' : 'class'), "BlockTitle");
      td6.innerHTML = '<div style="cursor:move;width:100%;background:#cccccc;padding:2px; border:1px solid #aeb0b5;">Action Details</div>';

      escTrHeader.appendChild(td8);
      td8.setAttribute('vAlign','top');
      td8.setAttribute('rowSpan', '3');
      td8.setAttribute((document.all ? 'className' : 'class'), "remove");
      td8.innerHTML ='<a href="#" onclick="removeRow(this);removeAction(' + actionId + ');"><html:img page="/images/tbb_delete.gif" height="16" width="46" border="0"  alt="" /></a>';

      escTr1.appendChild(td1);
      td1.setAttribute((document.all ? 'className' : 'class'), "waitTd");
      td1.setAttribute('colSpan', '2');
      td1.appendChild(waitDiv);
      waitDiv.setAttribute('id','wait_' + liID);
      waitDiv.setAttribute('width', '100%');
      waitDiv.innerHTML = "Wait time before escalating: " + actionWaitTime + "<br>";


      td1.appendChild(editWaitDiv);
      editWaitDiv.setAttribute('id','editWait_' + liID);

      escTr2.appendChild(td2);
      td2.setAttribute('width', '100%');
      td2.setAttribute('vAlign', 'top');
      td2.setAttribute((document.all ? 'className' : 'class'), "wrap");
      td2.appendChild(usersTextDiv);
      td2.setAttribute('id','usersList_' + liID);

      var actionClass = actionsClassName.split('.');

        for (var d = 0; d < actionClass.length; d++) {
            if (actionClass[d] == "SyslogAction") {
            usersTextDiv.innerHTML = '<table cellpadding="0" cellspacing="0" border="0"><tr><td rowSpan="3" vAlign="top" style="padding-right:3px;">Log to the Syslog:</td><td style="padding:0px 2px 2px 2px;">meta: ' + configMeta + '</td></tr><tr><td style="padding:2px;">product: ' + configProduct + '</td></tr><tr><td style="padding:2px 2px 2px 2px;">version: ' + configVersion + '</td></tr></table>'
           } else if (actionClass[d] == "NoOpAction") {
            usersTextDiv.innerHTML = 'Suppress duplicate alerts for: ' + actionWaitTime;
            waitDiv.innerHTML = "&nbsp;";
            }
       }

      if (configListType == "1"){
          var emailAdds = emailInfo.split(',');
          for (var b = 0; b < emailAdds.length; b++) {
              var displayEmails = "";
              var emailAdds = emailInfo.split(',');
              var comma = ", ";
              for (var b = 0; b < emailAdds.length; b++) {
                displayEmails += emailAdds[b];
                  
                if (b < emailAdds.length - 1) {
                  displayEmails += comma;
                }
              }

              if (configSms == "true") {
                usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Others"/> via SMS: " + displayEmails + "<br>";
              } else {
              usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Others"/> via Email: " + displayEmails + "<br>";

          }
              //usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Others"/>:  " + displayEmails + "<br>";

         }
           
      } else if (configListType == "2") {
          var uids = emailInfo.split(',');
          var userNames = "";
          for (var b = 0; b < uids.length; b++) {
               <c:forEach var="user" items="${AvailableUsers}" varStatus="status">
                  if (uids[b] == '<c:out value="${user.id}"/>') {
                      userNames += '<c:out value="${user.name}" />, ';
                  }
              </c:forEach>
          }
          
          if (configSms == "true") {
          usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Users"/> via SMS: " + userNames + "<br>";
              } else {
              usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Users"/> via Email: " + userNames + "<br>";
        
          }
      } else  if (configListType == "3") {
          var rids = emailInfo.split(',');
          var roleNames = "";
          for (var b = 0; b < rids.length; b++) {
              <c:forEach var="role" items="${AvailableRoles}" varStatus="status">
                  if (rids[b] == '<c:out value="${role.id}"/>') {
                      roleNames += '<c:out value="${role.name}" />, ';
                  }
              </c:forEach>
          }
          
          usersTextDiv.innerHTML = "<fmt:message key="monitoring.events.MiniTabs.Users"/>: " + roleNames + "<br>";
      }
  
      escTr2.appendChild(td3);
      td3.setAttribute((document.all ? 'className' : 'class'), "td3");
      td3.setAttribute('width', '20%');
      td3.setAttribute('vAlign', 'top');

      switch(configListType) {
      case 1:
        td3.innerHTML = emailInfo + "<br>";
        break;
      }
  
      td3.style.paddingTop = "5px";
  
      escTr2.appendChild(td4);
      td5.setAttribute('width', '50%');
  
      td4.appendChild(usersEditDiv);
      usersEditDiv.style.display = 'none';
      usersEditDiv.setAttribute('class', 'escInput'+ liID);
      usersEditDiv.setAttribute('id', 'usersEditDiv_'+ liID);
      usersEditDiv.setAttribute('width', '40%');
      usersEditDiv.innerHTML = " ";
      $('pauseTimeText').innerHTML = 'Allow user to pause escalation: ' + allowPause + "<br>";

    }

    Sortable.create('viewEscalationUL',{containment:'viewEscalationUL',
             onUpdate: function() {
               var pars = "&id=" + id;
               var url = '<html:rewrite action="/escalation/updateEscalationOrder"/>?' + Sortable.serialize("viewEscalationUL") + pars;
               new Ajax.Request(url, {method: 'post', onFailure :reportError});
           },
           constraint: 'vertical'});

    }
 
    function editEscalation () {
        $('escPropertiesTable').style.display = 'none';
        $('editPropertiesTable').style.display = '';
    }

    function cancelEditEscalation () {
        $('escPropertiesTable').style.display = '';
        $('editPropertiesTable').style.display = 'none';
    }

    function saveEscalation () {
        var pars = Form.serialize('EscalationForm');
        var url = '<html:rewrite action="/escalation/updateEscalation"/>';
        new Ajax.Request( url, {method: 'post', parameters: pars, onComplete: showViewEscResponse, onFailure: reportError} );
        $('escPropertiesTable').style.display = '';
        $('editPropertiesTable').style.display = 'none';
    }

    function saveAddEscalation () {
        // Convert whitespaces
        var emails = $('emailinput').value;
        $('emailinput').value = emails.split(/[\s]/);
        $('emailinput').value = emails.split(/,/);
        var id = $('id').value;
        var serialAddAction = Form.serialize('addEscalation');
        var pars =  "EscId=" + id + "&" + serialAddAction;
        var url = '<html:rewrite action="/escalation/saveAction"/>';
        
        new Ajax.Request( url, {method: 'post', parameters: pars, onComplete: updateEscView, onFailure: reportError} );
        document.addEscalation.reset();
    }

    function updateEscView( originalRequest ) {
        $('example').style.display= '';
        $('escMsg').innerHTML ="The action has been added to the escalation. The escalation is complete. You can add additional actions as needed.";
        cancelAddEscalation();
        setTimeout( "requestViewEscalation()", 1200 );
        //requestViewEscalation();
    }

    function hideAddEscButtons() {
     $('addEscButtons').style.display = "none";
     $('addRowButton').style.display = "";
    }

    function showAddEscButton() {
         $('addRowButton').style.display = "";
     }

    function addRow() {
        $(addEscalationUL).style.display = "";
        $('addEscButtons').style.display = "";
        $('noActions').style.display = "none";
        $('addRowButton').style.display = "none";
        var ni = $('addEscalationUL');
        var numi = document.getElementById('theValue');
        var num = (document.getElementById('theValue').value -1)+ 2;

        //numi.value = num;
        var liID = 'row'+num;
        var escLi = document.createElement('li');
        var usersDiv = document.createElement('div');
        var rolesDiv = document.createElement('div');
        var othersDiv = document.createElement('div');
        var emailDiv = document.createElement('div');
        var sysDiv = document.createElement('div');
        var escTable = document.createElement('table');
        var escTableBody = document.createElement('tbody');
        var escTrHeader = document.createElement('tr');
        var escTr1 = document.createElement('tr');
        var escTr2 = document.createElement('tr');
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var td3 = document.createElement('td');
        var td4 = document.createElement('td');
        var td5 = document.createElement('td');
        var td6 = document.createElement('td');
        var td7 = document.createElement('td');
        var select1 = document.createElement("select");
        var select2 = document.createElement("select");
        var select3 = document.createElement("select");
        var anchor = document.createElement("a");

        ni.appendChild(escLi);
        escLi.setAttribute((document.all ? 'className' : 'class'), "lineitem");
        escLi.setAttribute('id','row_'+ liID);

        escLi.appendChild(escTable);
        escTable.setAttribute((document.all ? 'className' : 'class'), "escTbl");
        escTable.setAttribute('border', '0');
        escTable.appendChild(escTableBody);
        escTableBody.appendChild(escTrHeader);
        escTableBody.appendChild(escTr2);
        escTableBody.appendChild(escTr1);
        /*
        escTrHeader.appendChild(td7);
        td7.setAttribute('rowSpan', '3');
        td7.setAttribute('width', '10');
        td7.innerHTML = "&nbsp;"
        */
        
        escTrHeader.appendChild(td6);
        td6.setAttribute('colSpan', '3');
        td6.setAttribute((document.all ? 'className' : 'class'), "BlockTitle");
        td6.innerHTML = '<div style="width:100%;background:#cccccc;padding:2px; border:1px dotted #aeb0b5;">Create an Action for this escalation</div>';

        escTrHeader.appendChild(td5);
                td5.setAttribute('vAlign', 'top');
                td5.setAttribute('width', '30%');
                td5.setAttribute('rowSpan', '3');
                td5.setAttribute('id', 'displaySelAction');
                td5.innerHTML = '<table cellpadding="2" cellspacing="0" border="0" width="100%"><tbody><tr><td class=BlockTitle colSpan=3>Action Details</td></tr><tr><td id="actionName" vAlign="top" width="50%">Action: Email</td></tr><tr><td id="userListDisplay" valign="top" style="display:none;"></td></tr><tr><td><table cellpadding="2" cellspacing="0" border="0"><tr><td id=metaText style="display:none"></td></tr><tr><td id=productText style="display:none"></td></tr><tr><td id=versionText style="display:none"></td></tr></table></td></tr><tr><td id="time" colspan="3" valign="top" style="display:none;"></td></tr></tbody></table>';


        escTr1.appendChild(td1);

        td1.setAttribute('colSpan', '3');
        td1.appendChild(document.createTextNode('<fmt:message key="alert.config.escalation.then"/> '));

        td1.appendChild(select1);
        select1.setAttribute('id', 'waittime_' + liID);
        select1.onchange = function(){onchange_time(this);}
        select1.setAttribute('name', 'waittime');
        addOption(select1, '0', '<fmt:message key="alert.config.escalation.end"/>');
        addOption(select1, '300000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="5"/>
                                    </fmt:message>');
        addOption(select1, '600000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="10"/>
                                    </fmt:message>');
        addOption(select1, '1200000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="20"/>
                                    </fmt:message>');
        addOption(select1, '1800000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="30"/>
                                    </fmt:message>');
        addOption(select1, '2700000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="45"/>
                                    </fmt:message>');
        addOption(select1, '3600000', '<fmt:message key="alert.config.escalation.wait">
                                      <fmt:param value="60"/>
                                    </fmt:message>');

        escTr2.appendChild(td2);
        td2.setAttribute('valign', 'top');
        td2.setAttribute('class', 'td2');

        td2.appendChild(select2);
        select2.setAttribute('id', 'Email_' + liID);
        select2.onchange = function(){onchange_handler(this);clearDisplay();clearOthers();}
        select2.setAttribute('name', 'action');
        addOption(select2, 'Email', 'Email');
        addOption(select2, 'SMS', 'SMS');
        addOption(select2, 'Syslog', 'Sys Log');
        addOption(select2, 'NoOp', 'Suppress Alerts');

        escTr2.appendChild(td3);
        td3.setAttribute('class', 'td3');
        td3.setAttribute('valign', 'top');

        td3.appendChild(select3);
        select3.setAttribute('name', 'who');
        select3.setAttribute('id', 'who_' + liID);
        select3.onchange = function(){onchange_who(this);clearDisplay();}
        addOption(select3, 'Select', '<fmt:message key="alert.config.escalation.notify.who"/>');
        <c:if test="${not empty AvailableRoles}">
        addOption(select3, 'Roles', '<fmt:message key="monitoring.events.MiniTabs.Roles"/>')
        </c:if>
        addOption(select3, 'Users', '<fmt:message key="monitoring.events.MiniTabs.Users"/>');
        addOption(select3, 'Others', '<fmt:message key="monitoring.events.MiniTabs.Others"/>');

        escTr2.appendChild(td4);
        td4.setAttribute('valign', 'top');
        
        td4.appendChild(emailDiv);
        emailDiv.setAttribute('class', 'emailDiv');
        emailDiv.setAttribute('id', 'emailinputDiv');
        $('emailinputDiv').style.display = 'none';
        $('emailinputDiv').innerHTML = "email addresses<br> (comma separated):<br><textarea rows=2 cols=20 id=emailinput name=emailinput onblur=checkEmail();copyOthersEmail(this);></textarea>";

        td4.appendChild(sysDiv);
        sysDiv.setAttribute('class', 'escInput');
        sysDiv.setAttribute('id', 'sysloginput');
        $('sysloginput').style.display = 'none';
        //sysDiv.setAttribute('width', '40%');
        sysDiv.innerHTML = "meta: <input type=text name=meta" + " size=30 onblur=copyMeta(this);><br>" + "product: <input type=text name=product" + " size=30 onblur=copyProduct(this);><br>" + "version: <input type=text name=version" + " size=30 onblur=copyVersion(this);><br>";

        td4.appendChild(usersDiv);
        usersDiv.setAttribute('id', 'usersDiv' + liID);
        $('usersDiv'+ liID).style.display = 'none';

        if($('usersList')) {
          usersDiv.innerHTML = $('usersList').innerHTML;
          var usersInputList = usersDiv.getElementsByTagName('input');
          for(i=0;i < usersInputList.length; i++) {
              var inputNamesArr = usersInputList[i];
              inputNamesArr.name = inputNamesArr.name;
          }
        }

        td4.appendChild(rolesDiv);
        rolesDiv.setAttribute('id', 'rolesDiv' + liID);
        $('rolesDiv'+ liID).style.display = 'none';

        if($('rolesList')) {
          rolesDiv.innerHTML = $('rolesList').innerHTML;
          var rolesInputList = rolesDiv.getElementsByTagName('input');
           for(i=0;i < rolesInputList.length; i++) {
                  var inputRolesArr = rolesInputList[i];
                  inputRolesArr.name =  inputRolesArr.name;
              }
          }

      }

      function copyOthersEmail(el) {
        var othersDisplay = $('userListDisplay');
          othersDisplay.style.display = "";
        othersDisplay.innerHTML = 'Notify email addresses: ' + el.value;
      }

      function copyMeta(el) {
        var metaDisplay = $('metaText');
        metaDisplay.style.display = "";
        metaDisplay.innerHTML = 'meta: ' + el.value;
      }

      function copyProduct(el) {
        var productDisplay = $('productText');
        productDisplay.style.display = "";
        productDisplay.innerHTML = 'product: ' + el.value;
      }

      function copyVersion(el) {
        var versionDisplay = $('versionText');
        versionDisplay.style.display = "";
        versionDisplay.innerHTML = 'version: ' + el.value;
      }

      function clearDisplay() {
       $('userListDisplay').innerHTML = "";
       $('metaText').innerHTML = "";
       $('productText').innerHTML = "";
       $('versionText').innerHTML = "";
       $('time').innerHTML = "";
      }

      function clearOthers() {
        $('emailinput').value = "";
        $('emailinputDiv').style.display = "none";
      }
      function onchange_handler(el) {
        //alert(el+", value="+ el.options[el.selectedIndex].value );
          $('userListDisplay').style.display= "";
        var writeAction = $('actionName');
        var index= el.options[el.selectedIndex].value


          writeAction.innerHTML = 'Action: ' +index;

         if (index == "Email" || index == "SMS" || index == "NoOp") {
            hideSyslogInput(el);
         }
         else {
            showSyslogInput(el);
         }

         if (index == "Syslog" || index == "NoOp") {
            hideWhoSelect(el);
         }
         else {
            showWhoSelect(el);
         }
      }

      function onchange_who(el) {
         clearOthers();
        $('userListDisplay').style.display= "";
        var index= el.options[el.selectedIndex].value
        var idStr = el.id;
        var getId = idStr.split('_');
        var rolesDivIn = $('rolesDiv' + getId[1]);
        var usersDivIn = $('usersDiv' + getId[1]);
        var emailDivIn = $('emailinputDiv');

        if (index == "Roles") {
           emailDivIn.style.display = 'none';
           configureRoles(idStr);
         } else if (index == "Users") {
           emailDivIn.style.display = 'none';
           configureUsers(idStr);
            //configureUsers(nodeId);
         } else if (index == "Others") {
           emailDivIn.style.display = '';
            $('emailinput').focus();
           //configureOthers(nodeId);
        }
      }

    function showWhoSelect(el) {
        var idStr = el.id;
        var getId = idStr.split('_');
        var whoSelector = $('who_' + getId[1]);
        whoSelector.style.display='';
    }

    function hideWhoSelect(el) {
        var idStr = el.id;
        var getId = idStr.split('_');
        var whoSelector = $('who_' + getId[1]);
        whoSelector.style.display='none';
    }

    function showSyslogInput(el) {

        var syslogDivIn = $('sysloginput');
        syslogDivIn.style.display='';
    }

    function hideSyslogInput(el) {

        var syslogDivIn = $('sysloginput');
        syslogDivIn.style.display='none';
    }

    function onchange_time(el) {
        //alert(el+", value="+ el.options[el.selectedIndex].value );
        var writeTime = $('time');
        writeTime.style.display = "";
        var index= el.options[el.selectedIndex].value;
        writeTime.innerHTML = 'Then wait: ' + (index / 60000) + ' minutes';
    }

    function hideDisplay() {
        $(emailinput).style.display='none';
        $(sysloginput).style.display='none';
    }

    function removeRow(obj) {
        var oTR = obj.parentNode.parentNode;
        var oTable = oTR.parentNode.parentNode;
        var oLi = oTable.parentNode;
        var root = oLi.parentNode;

        root.removeChild(oLi);
    }

    function addOption(sel, val, txt, selected) {
        var o = document.createElement('option');
        var t = document.createTextNode(txt);

        o.setAttribute('value',val);

        if (selected) {
          o.setAttribute('selected', 'true');
        }
        sel.appendChild(o);
        o.appendChild(document.createTextNode(txt));
      
    }

    function showResponse(originalRequest) {
        $('escMsg').innerHTML ="Escalation Saved";

    }

    function showResponseRemoved() {
        $('example').style.display= '';
        $('escMsg').innerHTML ="Action removed from this escalation";

        if ($('viewEscalationUL').firstChild) {
            $('noActions').style.display = "none";
            } else {
            $('noActions').style.display = "";
        }
    }

   function removeAction(id) {
        var urlBegin = '<html:rewrite action="/escalation/removeAction/';
        var urlEnd = '.do"/>';
        var url =  urlBegin + id + urlEnd;

        var id = $('id').value;
        var pars =  "EscId=" + id;

        new Ajax.Request( url, {method: 'post', parameters: pars, onComplete: showResponseRemoved, onFailure :reportError} );
   }
    
    function configure(id) {
      var sel = $('who' + id);
      var selval = sel.options[sel.selectedIndex].value;

      if (selval == 'Users') {
        // Select checkboxes based on existing configs
        insertUsers(this.id);
      }
      else if (selval == 'Others') {
        // Set the inner text
        insertOthers(this.id);
      }
      else if (selval == 'Roles') {
        // Select checkboxes based on existing configs
        insertRoles(this.id);
      }
    }

    function configureOthers(el) {
            var idStr = el;
            var getId = idStr.split('_');
            var othersDivIn = $('othersDiv_' + getId[1]);

      Dialog.confirm(othersDivIn.innerHTML,
                  {windowParameters: {className:'dialog', width:305, height:200,
                   resize:false, draggable:false},
                  okLabel: "OK", cancelLabel: "Cancel",
                  ok:function(win) {
                  // Do something
                    new Effect.Shake(Windows.focusedWindow.getId());
                    return true;
                  }});
    }

    function configureUsers(el) {
      var idStr = el;
      var getId = idStr.split('_');
      var usersDivIn = $('usersDiv' + getId[1]);
      var writeListUsers = $('userListDisplay');
      
      Dialog.confirm('<div id="usersConfigWindow">' + usersDivIn.innerHTML +
                     '</div>',
                  {windowParameters: {className:'dialog', width:305, height:200,
                   resize:false, draggable:false},
                  okLabel: "OK", cancelLabel: "Cancel",
                  ok:function(win) {
                    var usersInputList =
                      usersDivIn.getElementsByTagName('input');
                    var updatedInputList =
                      $('usersConfigWindow').getElementsByTagName('input');

                    writeListUsers.appendChild(document.createTextNode('Notify: '));

                    for(i = 0; i < usersInputList.length; i++) {

                        if (updatedInputList[i].checked) {
                          usersInputList[i].setAttribute("checked", "true");
                          }

                        if (usersInputList[i].checked) {
                            var checkedValues = usersInputList[i].value;
                            //alert('before: ' + checkedValues)
                            <c:forEach var="user" items="${AvailableUsers}" varStatus="status">
                            if (checkedValues == <c:out value="${user.id}"/>) {
                            writeListUsers.appendChild(document.createTextNode('<c:out value="${user.name}" /> '));
                            }
                            </c:forEach>
                            //writeListUsers.appendChild(document.createTextNode(checkedValues +' '));

                        }
                    }
                    new Effect.Fade(Windows.focusedWindow.getId())

                    return true;
                  }});
    }

    function configureRoles(el) {
      var idStr = el;
      var getId = idStr.split('_');
      var rolesDivIn = $('rolesDiv' + getId[1]);
      var writeListUsers = $('userListDisplay');

      Dialog.confirm('<div id="rolesConfigWindow">' + rolesDivIn.innerHTML +
                     '</div>',
                  {windowParameters: {className:'dialog', width:305, height:200,
                   resize:false, draggable:false},
                  okLabel: "OK", cancelLabel: "Cancel",
                  ok:function(win) {
                    var rolesInputList =
                      rolesDivIn.getElementsByTagName('input');                      
                    var updatedInputList =
                      $('rolesConfigWindow').getElementsByTagName('input');

                    writeListUsers.appendChild(document.createTextNode('Notify: '));

                    for(i = 0; i < rolesInputList.length; i++) {


                        if (updatedInputList[i].checked) {
                          rolesInputList[i].setAttribute("checked", "true");
                        }

                        if (rolesInputList[i].checked) {
                            var checkedValues = rolesInputList[i].value;
                            //alert('before: ' + checkedValues)
                            <c:forEach var="user" items="${AvailableRoles}" varStatus="status">
                            if (checkedValues == <c:out value="${user.id}"/>) {
                            writeListUsers.appendChild(document.createTextNode('<c:out value="${user.name}" /> '));
                            }
                            </c:forEach>
                            //writeListUsers.appendChild(document.createTextNode(checkedValues +' '));

                        }
                    }
                    new Effect.Fade(Windows.focusedWindow.getId());
                    return true;
                  }});
    }

    function schemeChange(sel) {
      document.EscalationSchemeForm.escId.value =
        sel.options[sel.selectedIndex].value;
      document.EscalationSchemeForm.submit();
    }

    function reportError(originalRequest) {
        alert('Error ' + originalRequest.status + ' -- ' + originalRequest.statusText);
    }


    function hideExample() {
            $('example').style.display= 'none';
    }

    function cancelAddEscalation() {
        $('addEscalationUL').innerHTML = "";
        $('addEscButtons').style.display = "none";
        $('addRowButton').style.display = "";
    }

    function checkEmail() {
        var emailinputText = $('emailinput');
        var illegalChars= /[\(\)\<\>\;\:\\\/\"\[\]]/;
        var elemText = emailinputText.value;

        if (elemText == '') {
        
        $('example').style.display= '';
        $('example').setAttribute((document.all ? 'className' : 'class'), "ErrorBlock");
        $('okCheck').innerHTML = "&nbsp;";
        $('escMsg').innerHTML ='<fmt:message key="error.Error.Tab"/> ' + '<fmt:message key="alert.config.error.noEmailAddressInput"/>';
        return false;

        } else if (elemText.match(illegalChars)) {

        $('example').style.display= '';
        $('example').setAttribute((document.all ? 'className' : 'class'), "ErrorBlock");
        $('okCheck').innerHTML = "&nbsp;";
        $('escMsg').innerHTML ='<fmt:message key="error.Error.Tab"/> ' + '<fmt:message key="alert.config.error.invalidEmailAddressInput"/>';
        return false;

        } else {
            $('escMsg').innerHTML ='';
            $('example').style.display= 'none';
        }

    }



</script>

<html:form action="/alerts/ConfigEscalation" method="GET">
  <html:hidden property="mode" />
  <c:choose>
    <c:when test="${not empty param.ad}">
      <input type="hidden" id="ad" name="ad"
        value='<c:out value="${param.ad}"/>' />
    </c:when>
    <c:when test="${not empty param.gad}">
      <input type="hidden" id="gad" name="gad"
        value='<c:out value="${param.gad}"/>' />
    </c:when>
  </c:choose>
  <c:if test="${not empty alertDef}">
    <c:choose>
      <c:when test="${not empty Resource}">
        <html:hidden property="eid" value="${Resource.entityId}" />
      </c:when>
      <c:otherwise>
        <html:hidden property="aetid" value="${ResourceType.appdefTypeKey}" />
      </c:otherwise>
    </c:choose>
  </c:if>
  <html:hidden property="escId" />
</html:form>

<div id="example" style="display:none;" class="ConfirmationBlock">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
  <td style="padding-right:5px;" id="okCheck"><html:img page="/images/tt_check.gif" height="9" width="9" border="0" alt=""/>
  </td>
  <td width="100%">
    <div id="escMsg"></div>
  </td>
    </tr>
</table>
</div>

<form action='<html:rewrite action="/escalation/saveEscalation"/>'
  name="EscalationForm" id="EscalationForm" onchange="hideExample();"><input
  type="hidden" value="0" id="pid"> <input type="hidden" value="0"
  id="pversion"> <input type="hidden" value="0"
  id="if the escalation is new or not"> <input type="hidden" value="0"
  id="theValue"> <c:choose>
  <c:when test="${not empty Resource}">
    <html:hidden property="eid" value="${Resource.entityId}" />
  </c:when>
  <c:otherwise>
    <html:hidden property="aetid" value="${ResourceType.appdefTypeKey}" />
  </c:otherwise>
</c:choose> <c:choose>
  <c:when test="${not empty param.ad}">
    <input type="hidden" id="ad" name="ad" value='<c:out value="${param.ad}"/>' />
  </c:when>
  <c:when test="${not empty param.gad}">
    <input type="hidden" id="gad" name="gad"
      value='<c:out value="${param.gad}"/>' />
  </c:when>
</c:choose>
  <input type="hidden" id="ffff" name="ggg" value='<c:out value="${escalation.id}"/>' />
  <input type="hidden" id="escId" name="id"/>

<table width="100%" cellpadding="4" cellspacing="0" border="0" id="escPropertiesTable">
  <tbody>
    <tr>
      <td class="BlockTitle" colSpan="2">
      <fmt:message key="alert.config.escalation.scheme" />
      </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <fmt:message key="common.label.Name" />
      </td>
      <td width="80%" id="name" class="BlockLabel" style="text-align:left"></td>
    </tr>
    <tr>
      <td class="BlockLabel" valign="top">
          <fmt:message key="common.label.Description" />
      </td>
      <td id="description" class="BlockContent"></td>
    </tr>
    <tr>
      <td class="BlockLabel" nowrap="true"><fmt:message key="alert.config.escalation.acknowledged"/></td>
      <td id="acknowledged" class="BlockContent"></td>
    </tr>
    <tr>
      <td class="BlockLabel" nowrap="true"><fmt:message key="alert.config.escalation.state.change"/></td>
      <td id="changed" class="BlockContent"></td>
    </tr>
    <tr class="ToolbarContent"><!-- EDIT TOOLBAR -->
      <td colSpan="2">
        <tiles:insert page="/common/components/ActionButton.jsp">
          <tiles:put name="labelKey" value="common.label.Edit"/>
          <tiles:put name="buttonHref" value="."/>
          <tiles:put name="buttonClick" value="editEscalation(); return false;"/>
        </tiles:insert>
      </td>
    </tr>
  </tbody>
</table>

<table width="100%" cellpadding="3" cellspacing="0" border="0" id="editPropertiesTable" style="display: none;">
  <tbody>
    <tr>
      <td class="BlockTitle" colSpan="2"><fmt:message key="alert.config.escalation.scheme"/></td>
    </tr>
    <tr>
      <td class="BlockContent">
        <table width="100%" cellpadding="4" cellspacing="0">
          <tr>
            <td class="BlockLabel">
              <fmt:message key="common.label.Name" />
            </td>
            <td width="80%">
              <input type="text" size="25" name="name" id="escName" />
            </td>
          </tr>
          <tr>
            <td class="BlockLabel" valign="top">
              <fmt:message key="common.label.Description" />
            </td>
            <td>
              <textarea cols="40" rows="4" name="description" id="escDesc"></textarea>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="BlockTitle"><fmt:message key="alert.config.escalation.acknowledged"/></td>
    </tr>
    <tr class="BlockContent">
      <td style="padding-left:15px;padding-bottom:10px;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tbody>
          <tr>
            <td style="padding-top:2px;padding-bottom:2px;"><input
              type="radio" name="allowPause" id="allowPauseTrue" value="true" /> <fmt:message
              key="alert.config.escalation.allow.pause" /> <select
              id="maxWaitTime" name="maxWaitTime">
              <option value="300000">5 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
              <option value="600000">10 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
              <option value="1200000">20 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
              <option value="1800000">30 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
              <option value="2700000">45 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
              <option value="3600000">60 <fmt:message
                key="alert.config.props.CB.Enable.TimeUnit.1" /></option>
            </select></td>
          </tr>
          <tr>
            <td style="padding-top:2px;padding-bottom:2px;"><input
              type="radio" name="allowPause" id="allowPauseFalse" value="false" checked="true" /> <fmt:message
              key="alert.config.escalation.allow.continue" /></td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr>
      <td class="BlockTitle"><fmt:message
        key="alert.config.escalation.state.change" /><br>
      </td>
    </tr>
    <tr class="BlockContent">
      <td style="padding-left:15px;padding-bottom:10px;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tbody>
          <tr>
            <td style="padding-top:2px;padding-bottom:2px;"><input
              type="radio" name="notifyAll" id="notifyAllFalse" value="false" checked="true" /> <fmt:message
              key="alert.config.escalation.state.change.notify.previous" /></td>
          </tr>
          <tr>
            <td style="padding-top:2px;padding-bottom:2px;"><input
              type="radio" name="notifyAll" id="notifyAllTrue" value="true" /> <fmt:message
              key="alert.config.escalation.state.change.notify.all" /></td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr class="ToolbarContent"><!-- SET TOOLBAR -->
      <td>
        <table cellspacing="4" cellpadding="0">
        <tr><td>
        <tiles:insert page="/common/components/ActionButton.jsp">
          <tiles:put name="labelKey" value="common.label.Save"/>
          <tiles:put name="buttonHref" value="."/>
          <tiles:put name="buttonClick" value="saveEscalation(); return false;"/>
        </tiles:insert>
        </td><td>
        <tiles:insert page="/common/components/ActionButton.jsp">
          <tiles:put name="labelKey" value="common.label.Cancel"/>
          <tiles:put name="buttonHref" value="."/>
          <tiles:put name="buttonClick" value="cancelEditEscalation(); return false;"/>
        </tiles:insert>
        </td></tr></table>
      </td>
    </tr>
  </tbody>
</table>


<div id="usersList" style="display:none;">
<div class="ListHeader">Select Users</div>
<ul class="boxy">
  <c:forEach var="user" items="${AvailableUsers}" varStatus="status">
    <li class="BlockContent"><input type="checkbox" name="users"
      value="<c:out value="${user.id}"/>"> <BLK><c:out
      value="${user.name}" /></BLK></input></li>
  </c:forEach>
</ul>
</div>
<c:if test="${not empty AvailableRoles}">
  <div id="rolesList" style="display: none;">
  <div class="ListHeader">Select Roles</div>
  <ul class="boxy">
    <c:forEach var="role" items="${AvailableRoles}" varStatus="status">
      <li class="BlockContent"><input type="checkbox" name="roles"
        value="<c:out value="${role.id}"/>"> <BLK><c:out
        value="${role.name}" /></BLK></input></li>
    </c:forEach>
  </ul>
  </div>
</c:if>

</form>

<br/>

<form name="viewEscalation" id="viewEscalation" style="display:none;">
    <input type="hidden" id="alertDefId" name="alertDefId"
  value='<c:out value="${alertDef.id}"/>' />
    <input type="hidden" value="" id="creationTime"> <input type="hidden"
      value="" id="_version_"> <input type="hidden" value="" id="notifyAll">
    <input type="hidden" value="" id="modifiedTime"> <input type="hidden"
      value="" id="allowPause"> <input type="hidden" value="" id="escName">
    <input type="hidden" value="" id="id">

<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <thead>
         <tr>
             <td class="BlockTitle" valign="top" nowrap colspan="2">
                 <table width="100%" cellpadding="0" cellspacing="0" border="0">
                     <tr>
                         <td class="BlockTitle" valign="top" nowrap>Step 2 - Create <fmt:message key="common.label.EscalationSchemeActions"/></td>
                         <td align="right" style="padding-right:3px;">
                         <html:img page="/images/icon_info2-60A5EA.gif" onmouseover="menuLayers.show('actionsInfoPopup', event)" onmouseout="menuLayers.hide()" border="0"/>
                        </td>
                     </tr>
                 </table>
               </td>

        </tr>
     </thead>
  <tbody>
    <tr class="BlockContent">
      <td style="padding-left:15px;padding-bottom:0px;display:none;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tbody>
          <tr>
            <td style="padding-top:0px;padding-bottom:0px;">
            <div id="pauseTimeText"></div>
            </td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    <tr class="BlockContent">
        <td id="noActions" style="padding:5px;display:none;"><b><fmt:message key="inform.config.escalation.scheme.newAction.noactions"/></b>

        </td>
    </tr>
    <tr>
      <td width="100%" id="viewSection" style="display:none;">
      <ul id="viewEscalationUL" style="margin-left:0px;"></ul>
      </td>
    </tr>
   </tbody>
</table>
</form>
 <form name="addEscalation" id="addEscalation">
 <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tbody>
      <tr>
      <td width="100%" id="addSection">
      <ul id="addEscalationUL" style="margin-left:0px;">
      </ul>
      </td>
    </tr>
    <tr class="ToolbarContent">
      <td id="addRowButton">
        <table cellspacing="4" cellpadding="0">
        <tr>
          <td>
        <tiles:insert page="/common/components/ActionButton.jsp">
          <tiles:put name="labelKey" value="common.label.AddAction"/>
          <tiles:put name="buttonHref" value="#"/>
          <tiles:put name="buttonClick" value="addRow(); return false;"/>
        </tiles:insert>
        </td>
        </tr>
       </table>
       </td>
    </tr>
    <tr class="ToolbarContent">
      <td id="addEscButtons" style="display:none">
        <table cellspacing="4" cellpadding="0" border="0">
        <tr>
            <td>
            <tiles:insert page="/common/components/ActionButton.jsp">
            <tiles:put name="labelKey" value="common.label.Save"/>
              <tiles:put name="buttonHref" value="#"/>
            <tiles:put name="buttonClick" value="saveAddEscalation(); return false;"/>
            </tiles:insert>
            </td>
            <td>
            <tiles:insert page="/common/components/ActionButton.jsp">
            <tiles:put name="labelKey" value="common.label.Cancel"/>
            <tiles:put name="buttonHref" value="#"/>
            <tiles:put name="buttonClick" value="cancelAddEscalation();"/>
            </tiles:insert>
            </td>
        </tr>
        </table>
      </td>
    </tr>
</tbody>
</table>
</form>
<div id="actionsInfoPopup" class="menu" style="padding:3px;">
<fmt:message key="inform.config.escalation.scheme.newAction.dragaction"/>
</div>

<br>
<br>
