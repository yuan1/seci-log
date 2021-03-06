<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title>告警查看</title>
</head>

<body>
${menutitle}
<div class="center-body">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12">
                <div class="layout">
                    <div class="header"><span>告警查看</span></div>
                    <div class="body">
                        <div class="layout-inner row">

                            <div class="data-ctrl">
                                    <div class="btn-group">
                                        <a class="btn btn-default" id="alertConfirm">告警确认</a>
                                    </div>
                                <form class="col-xs-5">
                                    <div class="input-group">
                                    	<div class="control-group col-xs-4" style="height:34px;">
                                    		<div class="controls">
                                    			<input type="text" placeholder="告警编码" name="search_LIKE_alertCode" id="search_LIKE_alertCode" class="form-control  col-xl-5" value="${param.search_LIKE_alertCode}"/>
                                    		</div>
                                    	</div>
                                    	<div class="control-group col-xs-4" style="padding-right:0px; height:34px;">
                                    		<div class="controls">
	                                   			<input type="text" placeholder="目标IP" name="search_LIKE_objectAddress" id="search_LIKE_objectAddress" class="form-control col-xl-5" value="${param.search_LIKE_objectAddress}"/>
	                                   		</div>
	                                   	</div>
                                    	<div class="control-group col-xs-4" style="padding-right:0px; height:34px;">
                                    		<div class="controls">
	                                   		        <select id="search_LIKE_processType" name="search_LIKE_processType" class="form-control col-xl-5">
	                                   		          <option value ="">状态</option>
	                                   		          <option value ="new">新告警</option>
													  <option value ="ticket">工单处理中</option>
													  <option value ="error">误报</option>
													  <option value="low">级别较低</option>
													  <option value="complete">已处理</option>
													  <option value="repeat">重复</option>
													</select>	                                   		
											</div>
	                                   	</div>

                                        <span class="input-group-addon" id="btnSearch" title="搜索"><i class="glyphicon glyphicon-search"></i></span>
                                    </div>
                               </form>
                            </div>

                            <div class="data-body">
                                <table width="100%" class="table table-bordered table-striped table-hover">
                                    <thead><tr><th width="6%"><label title="全选"><input type="checkbox" name="checkAll" id="checkAll">  选择</label></th>
                                    		   <th width="5%">规则编码</th><th width="8%">规则名称</th><th width="15%">告警时间</th><th width="10%">目标IP</th>
                                    	       <th width="5%">级别</th><th width="5%">日志数量</th><th width="25%">描述</th><th width="8%">状态</th><th width="8%">详情</th></tr></thead>
                                    <tbody>
                                    <tbody>
                                    <c:forEach items="${objects.content}" var="object">
                                        <tr>
                                        	<td><input type="checkbox" name="alertList" value="${object.id}" data-id="${object.processType}"></td>
                                            <td>${object.alertCode}</td>
                                            <td>${object.ruleName}</td>
                                            <td>
                                                <fmt:formatDate value="${object.alertDate}" pattern="yyyy年MM月dd日  HH时mm分ss秒" />
                                            </td>
                                            <td>${object.objectAddress}</td>
                                            <td>${object.degree}</td>
                                            <td>${object.eventCount}</td>
                                            <td>${object.displayDetail}</td>
                                            <td>${object.processType}</td>
                                            <td><a href="${ctx}/safemonitor/alert/event/${object.id}" title="详情">详情</a></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="data-page"><tags:pagination page="${objects}" paginationSize="5"/></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal">
    <div class="modal-dialog error-box">
        <div class="modal-content" style="margin:200px auto 0px; width:600px;">
        </div>
    </div>
</div>

<script type="text/javascript">
	<c:if test="${not empty message}">
	$(function(){
	    var _code = ${code};
	    $('#modal').find('.modal-content').html('<div id="message" class="alert ' + (function(){if(_code == 100)return 'alert-success';else return 'alert-danger';})() + '" style="margin-bottom:0px;"><button data-dismiss="modal" class="close">×</button>${message}</div>');
	    $('#modal').modal('toggle');
	    setTimeout(function(){$('#modal').modal('hide')},2000)
	});
	</c:if>
	
    $(function(){
        $('#btnSearch').on('click',function(){
        	$('form').attr('action',"${ctx}/safemonitor/alert");
            $('form').submit();
        });
        $('#search_LIKE_targetIp').on('keyup',function(e){
            if(e.keyCode == 13){
            	$('form').attr('action',"${ctx}/safemonitor/eventlog");
                $('form').submit();
            };
        });
        
    	$('#checkAll').on('change',function(){
    		var _checkBox = $('input[name="alertList"]');
    		var _count = _checkBox.length;
    		if($(this).is(":checked")){
    			for(var i = 0; i < _count; i++){
    				 _checkBox[i].checked = true;
    				 var objectId = $(_checkBox[i]).attr("data-id");
   		       		if ( objectId != 'new' ){
   		       			alert("已经处理过了，不能重复处理！");
   		       			$(_checkBox[i]).attr("checked", false);  
   		       			$(this).attr("checked", false);   
   		           		return;
   		       		}
    			}
    		}else{
    			for(var i = 0; i < _count; i++){
   				 _checkBox[i].checked = false;
	   			}
    		}
    	})
    	
   	    $('input[name="alertList"]').change(function(){    
   	    	if ( $(this).prop("checked") ){
   	    		var objectId = $(this).attr("data-id");
	       		if ( objectId != 'new' ){
	       			alert("已经处理过了，不能重复处理！");
	       		    $(this).attr("checked", false);     
	           		return;
	       		}
   	    	}
        });
    	
        $('#alertConfirm').on('click',function(){
        	var str="";  
			
        	$('input[name="alertList"]:checked').each(function(){    
        		str+="alertList="+$(this).val()+"&";
            });
        	if (str.length == 0){
        		alert("请选择告警！");
        		return;
        	}
        	str = str.substr(0,str.length-1);
        	$("#alertConfirm").attr("href","${ctx}/safemonitor/alert/alertConfirm?"+str);
        	$("#alertConfirm").click();
        });
    });
</script>
</body>
</html>
