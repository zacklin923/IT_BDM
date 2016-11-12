<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>站点资料统计</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/themes/yellow/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/demo/demo.css">
	<script type="text/javascript" src="<%=path %>/FRAMEWORK/jquery-easyui/jquery.min.js"></script>
	<script type="text/javascript" src="<%=path %>/FRAMEWORK/jquery-easyui/jquery.easyui.min.js"></script>
	
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/css/mycss.css">
	<script type="text/javascript">
	$(function(){
		if('${filtrate}'=='W'){
			$('#dates').attr('type','week');
			$('#datee').attr('type','week');
		}
		if('${filtrate}'=='M'){
			$('#dates').attr('type','month');
			$('#datee').attr('type','month');
		}
		if('${filtrate}'=='Y'){
			$('#dates').attr({type:"number" ,min:"1900" ,max:"2199"});
			$('#datee').attr({type:"number" ,min:"1900" ,max:"2199"});
		}
		$("#sel_dt option[value='${filtrate}']").attr("selected",true);
		$("#sele option[value='"+${page.size}+"']").attr("selected",true);
		$("#eidtASubjectWindow1").show();
		$('#tt').show();
	});
	function page(no,cz){
		var num1=$('#page').val();
		if(cz==1){//上下页
			$('#page').val(num1*1+no*1);
		}else if(cz==2){//首末页
			$('#page').val(no);
		}else{
		}
		if($('#page').val()*1<1){
			$('#page').val(1);
		}else if($('#page').val()*1>${page.pageMax}*1){
			$('#page').val(${page.pageMax});
		}
		$('#f1').submit();
	}
	</script>
	<script type="text/javascript">
	function queryDetails(dates,datee) {
		var a1=new Array()
		a1=dates.split(" ");
		//console.log(a1[0]);
		var a2=new Array()
		a2=datee.split(" ");
		//console.log(a2[0]);
		var path="<%=path%>/site!queryOfFenye?cz=no&id=&dates="+a1[0]+"&datee="+a2[0];
		//console.log(path);
		window.location.href=path;
	}
	function changeDate(){
		if($('#sel_dt').val()=='W'){
			$('#dates').attr('type','week');
			$('#datee').attr('type','week');
		}
		if($('#sel_dt').val()=='M'){
			$('#dates').attr('type','month');
			$('#datee').attr('type','month');
		}
		if($('#sel_dt').val()=='Y'){
			$('#dates').attr({type:"number" ,min:"1900" ,max:"2199"});
			$('#datee').attr({type:"number" ,min:"1900" ,max:"2199"});
		}
	}
	function xiazai(){
		var path ="<%=path %>/siteCount!exportExc";
		window.location.href=path;
	}
	</script>
	
	<style>
	  .tab {
	    background-color: #B00000;
	    color: white;
	    padding: 10px;
	    width: 100px;
	    text-align: center;
	    -moz-border-radius:20px;  
        -webkit-border-radius:20px;  
        cursor: pointer;
	  }
	</style>
  </head>
  <%boolean isAddColor=false; %>
  <body>
 	<div style="text-align: center;margin-right: 17px;color: white;background-color:#17B4FF;padding: 5px;font-size: 14px;font-weight:bold;">站点资料统计</div>
 	
 	
	<div style="background-color:white;margin-bottom: 5px;padding: 5px;border: 1px solid #224466;margin-right: 17px;margin-top: 10px;">
    	快速查询
    	<br/>
    	<form action="<%=path %>/siteCount!queryOfFenye" method="post">
    		当前查询条件:
    		<select id="sel_dt" name="filtrate" onchange="changeDate()">
    			<option value="W">周</option>
    			<option value="M">月</option>
    			<option value="Y">年</option>
    		</select>
    		&nbsp;&nbsp;&nbsp;&nbsp;
    		选择日期:<input id="dates" name="dates"  value="${dates }"/>
    		~
    		<input id="datee" name="datee"  value="${datee }"/>
    		<br/>
    		<input type="submit" value="查询"/>
    		<input type= "button" onclick="xiazai()" value="导出" />
    	</form>	
    </div>
    <div style="margin-bottom: 5px;">
	    
	    
  	<div style="margin-right: 17px;">
    <table border="1" id="" style="font-size: 12px;">
	    <tr>
	    	<th>序号</th>
	    	<th>开始时间</th>
	    	<th>结束时间</th>
	    	<th>
	    		<c:if test="${filtrate=='W'}">周</c:if>
	    		<c:if test="${filtrate=='M'}">月</c:if>
	    		<c:if test="${filtrate=='Y'}">年</c:if>
	    		数</th>
	    	<th>维护类型</th>
	    	<th>维护数量</th>
	    	<th>操作</th>
	    </tr>
	    <c:forEach items="${counts}" var="count" varStatus="status">
	    <c:if test="${count.rows!=0}">
    		<%isAddColor=!isAddColor; %>
   		</c:if>
	   	<%if(isAddColor){ %>
	    <tr class="odd_even_tr">
	    <%}else{ %>
	    <tr>
	    <%} %>
	    	<c:if test="${count.rows!=0}">
	    		
		    	<td rowspan="${count.rows}">${count.orderNum }</td>
		    	<td rowspan="${count.rows}"><fmt:formatDate value="${count.sTime }" pattern="yyyy-M-d HH:mm:ss" /></td>
		    	<td rowspan="${count.rows}"><fmt:formatDate value="${count.eTime }" pattern="yyyy-M-d HH:mm:ss" /></td>
	    		<td rowspan="${count.rows}">${count.num }</td>
	    	</c:if>
	    	<td>${count.type }</td>
	    	<td>${count.count }</td>
	    	<td>
				<a onclick="queryDetails('${count.sTime}','${count.eTime }')" class="easyui-linkbutton" title="查看详情">查看详情</a>
			</td>
	    </tr>
	    </c:forEach>
	    </table>
		</div>
  	</div>
  	
	   
	<div id="q" class="easyui-window" title="查看详情" data-options="modal:true,closed:true" style="width:1400px;height:600px;padding:10px;display: none;">
	</div>
	
	
	
  </body>
</html>
