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
    
    <title>用户管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/themes/${theme }/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/jquery-easyui/demo/demo.css">
	<script type="text/javascript" src="<%=path %>/FRAMEWORK/jquery-easyui/jquery.min.js"></script>
	<script type="text/javascript" src="<%=path %>/FRAMEWORK/jquery-easyui/jquery.easyui.min.js"></script>
	
	<script type="text/javascript" src="<%=path %>/FRAMEWORK/js/myjs.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=path %>/FRAMEWORK/css/mycss.css">
	<script type="text/javascript">
	$(function(){
		$("#sele option[value='"+${page.size}+"']").attr("selected",true);
		$("#eidtASubjectWindow1").show();
		$('#tt').show();
		$('.easyui-tree').tree('collapseAll');
		$('#cc1').combo({
			required:true,
			editable:false
		});
		$('#sp1').appendTo($('#cc1').combo('panel'));
		$('#sp1 li div').click(function(){
			var f = $(this).find('font').text();
			var t = $(this).find('.tree-title');
			var str=$("<span>"+t.html()+"</span>");
			str.find('font').remove();
			$('#cc1').combo('setValue', f).combo('setText', str.text());
		});
		$('#cc2').combo({
			required:true,
			editable:false
		});
		$('#sp2').appendTo($('#cc2').combo('panel'));
		$('#sp2 li div').click(function(){
			var f = $(this).find('font').text();
			var t = $(this).find('.tree-title');
			var str=$("<span>"+t.html()+"</span>");
			str.find('font').remove();
			$('#cc2').combo('setValue', f).combo('setText', str.text());
		});
	});
	function trans_radio(str){
		if (str=="在职") {
			return 0;
		}else if (str=="离职") {
			return 1;
		}
	}
	function update(u1,u2,u3,u4,u5,u6,u7,u8){
		$('#u').window('open');
		$('#u_1').val(u1);
		$('#u_2').val(u2);
		$('#u_3').val(u3);
		$('#cc2').combo('setText',u4);
		$('#cc2').combo('setValue',u4);
		$('#u_5').val(u5);
		$("#u_6 option[value='"+u6+"']").attr("selected",true);
		$('#u_7').val(u7);
		$("#u_8_"+trans_radio(u8)).click();
	}
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
	function check(){
		var a=$("#a_1").val();
		if($.trim(a)==""){
			alert("账号不能为空!");
			return false;
		}else{
			return true;
		}
	}
	</script>
  </head>
  
  <body>
    
    <div class="easyui-panel" title="用户管理" style="width:100%;padding: 5px;display: none;" data-options="tools:'#tt'">
    
    <div style="margin-bottom: 5px;">
    <table border="1" style="font-size: 12px;">
	    <tr>
	    	<th>账号</th>
	    	<th>密码</th>
	    	<th>名字</th>
	    	<th>部门</th>
	    	<th>职位</th>
	    	<th>邮箱</th>
	    	<th>创建时间</th>
	    	<th>角色</th>
	    	<th>状态</th>
	    	<th>操作</th>
	    </tr>
	    <c:forEach items="${us}" var="u">
	    <tr>
			<td width="">${u.UNum }</td>
			<td width="">${u.UPass }</td>
			<td width="">${u.UName }</td>
			<td width="">${u.csGroup }</td>
			<td width="">${u.UJob }</td>
			<td width="">${u.UMail }</td>
			<td width="">${u.UStartTime }</td>
			<td width="">${u.r.RName }</td>
			<td width="">${u.UState }</td>
			<td width="5%" align="center">
				<a onclick="update('${u.UNum }','${u.UPass }','${u.UName }','${u.csId }','${u.UJob }','${u.RId }','${u.UMail }','${u.UState }')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" title="修改"></a>
				<a href="<%=path %>/users!delete?id=${u.UNum}" onclick="return confirm('确定删除吗?')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-delete'" title="删除"></a>
			</td>
	    </tr>
	    </c:forEach>
    </table>
	</div>
	
	<div class="easyui-panel" style="width: 100%;padding:5px;display: none;background-color: white;">
		<form id="f1" action="<%=path %>/users!queryOfFenye" method="post">
		<select id="sele" style="float: left;margin-top: 3px;margin-left: 5px;" name="page.size" onchange="$('#f1').submit();">
			<option value="5">5</option>
			<option value="10">10</option>
			<option value="15">15</option>
		</select>
		
		<span style="float: left;margin-left: 5px;">
		<span style="color: #A5A5A5;">|</span>
		<a onclick="page(1,2)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-last'" title="首页"></a>
		<a onclick="page(-1,1)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-l'" title="上一页"></a>
		<span style="color: #A5A5A5;">|</span>
		</span>
		
		<span style="float: left;margin-top: 3px;margin-left: 5px;">
		<input id="page" name="page.pageOn" type="number" style="width: 50px;height: 20px;" value="${page.pageOn }" min="1" max="${page.pageMax }" onchange="$('#f1').submit();"/>
		</span>
		
		<span style="float: left;margin-top: 5px;margin-left: 5px;">/${page.pageMax }</span>
		
		<span style="float: left;margin-left: 5px;">
		<span style="color: #A5A5A5;">|</span>
		<a onclick="page(1,1)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-n'" title="下一页"></a>
		<a onclick="page('${page.pageMax}',2)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-next'" title="末页"></a>
		</span>
		</form>
	</div>
	</div>
	
	<div id="u" class="easyui-window" title="修改" data-options="modal:true,closed:true" style="width:400px;height:auto;padding:10px;display: none;top: 200px;">
		<form action="<%=path %>/users!update" method="post">
		<table border="0" class="table1">
			<tr>
				<td width="70">账号：</td>
				<td>
					<input id="u_1" name="u.UNum" type="text" style="width: 100%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td>密码：</td>
				<td>
					<input id="u_2" name="u.UPass" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>名字：</td>
				<td>
					<input id="u_3" name="u.UName" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>部门：</td>
				<td>
					<select name="u.csId" id="cc2" style="width:100%;"></select>
					<div id="sp2">
						<div style="color:#99BBE8;background:#fafafa;padding:5px;">选择公司组织架构</div>
						${html }
					</div>
				</td>
			</tr>
			<tr>
				<td>职位：</td>
				<td>
					<input id="u_5" name="u.UJob" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>邮箱</td>
				<td>
					<input id="u_7" name="u.UMail" type="email" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>角色：</td>
				<td>
					<select id="u_6" name="u.RId">
						<c:forEach items="${rs}" var="r">
						<option value="${r.RId }">${r.RName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>状态</td>
				<td>
					<input id="u_8_0" type="radio" name="u.UState" value="在职"/>在职
					<input id="u_8_1" type="radio" name="u.UState" value="离职"/>离职
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input class="easyui-linkbutton" type="submit" style="width: 95%;padding: 5px;" value="提交"/>
				</td>			
			</tr>
		</table>
		</form>
	</div>
	
	<div id="a" class="easyui-window" title="添加" data-options="modal:true,closed:true" style="width:400px;height:auto;padding:10px;display: none;top: 200px;">
		<form action="<%=path %>/users!add" method="post">
		<table border="0" class="table1">
			<tr>
				<td width="70">账号：</td>
				<td>
					<input id="a_1" name="u.UNum" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>密码：</td>
				<td>
					<input name="u.UPass" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>名字：</td>
				<td>
					<input name="u.UName" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>部门：</td>
				<td>
					<select name="u.csId" id="cc1" style="width:100%;"></select>
					<div id="sp1">
						<div style="color:#99BBE8;background:#fafafa;padding:5px;">选择公司组织架构</div>
						${html }
					</div>
				</td>
			</tr>
			<tr>
				<td>职位：</td>
				<td>
					<input name="u.UJob" type="text" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>邮箱</td>
				<td>
					<input name="u.UMail" type="email" style="width: 100%;"/>
				</td>
			</tr>
			<tr>
				<td>角色：</td>
				<td>
					<select name="u.RId">
						<c:forEach items="${rs}" var="r">
						<option value="${r.RId }">${r.RName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input onclick="return check()" class="easyui-linkbutton" type="submit" style="width: 95%;padding: 5px;" value="提交"/>
				</td>			
			</tr>
		</table>
		</form>
	</div>
	
	<div id="tt" style="display: none;">
		<a class="icon-add" onclick="$('#a').window('open')" style="margin-left: 10px;" title="添加"></a>
	</div>
	
  </body>
</html>
