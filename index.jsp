
<%@page import="mysql.jdbbean"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mysql.html"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.*"%>
<%@page import="mysql.mysql"%>
<%
    html h=new html();
    mysql my=new mysql();
    jdbbean b=new jdbbean();
    String db = request.getParameter("db");
    String table = request.getParameter("table");
    String tab = request.getParameter("tab");
    String action = request.getParameter("action");
    String key = request.getParameter("key");
    String value = request.getParameter("value");
    String col = request.getParameter("column");
    String error = request.getParameter("error");
    String pg = request.getParameter("pg");
    b.setTable(table);
    h.setbean(b);
    my.setbean(b);
    b.setDb(db);
    my.setDB(db);
    if(pg == null){ b.setPage(0);my.setpg(0);}else{ b.setPage(Integer.parseInt(pg));my.setpg(Integer.parseInt(pg));}
    session = request.getSession(true);
    //out.write(request.getRequestURL().toString()+ request.getQueryString().toString());
%>
<html>
<head>
<title>JDBMngr</title>
<LINK rel="SHORTCUT ICON" href="Images/logo.png"/>
<link rel="stylesheet" type="text/css" href="css/style.css">
<link rel="stylesheet" type="text/css" href="css/tab.css">
<link rel="stylesheet" href="css/login.css">
<script src="js/jdbmngr.js"></script> 
<script src="js/alert.js"></script>
<%
    if((tab+"_").equals("query_")){
        out.write(h.querycssjs());
    }
    if((tab+"_").equals("import_")){
        out.write(h.getImportjs());
    }
    if(tab == null){
        tab = "Home";
    }
%>
</head>
<body style="margin: 0px;padding: 0px;">
<div id="cont">
<%
    String user = null,pass = null,host = null,port = null;
    String title = "";
    String[] login = new String[5];
    login = (String[])session.getAttribute("JDBMnger_login_19091991");
    
    String[] getlogin = new String[5];
    //===============================================================================
    if(login == null || (request.getParameter("login")+"_").equals("Login_")){
        if(request.getParameter("user") != null){
            user = request.getParameter("user").toString();
        }
        if(request.getParameter("pass") != null){
            pass = request.getParameter("pass").toString();
        }
        if(request.getParameter("host") != null){
            host = request.getParameter("host").toString();
        }
        if(request.getParameter("port") != null){
            port = request.getParameter("port").toString();
        }
        boolean JDBlogin = my.isvalid(user,pass,host,port);
        getlogin[0] = user; 
        getlogin[1] = pass; 
        getlogin[2] = host; 
        getlogin[3] = port; 
        //if(JDBlogin){
            session.setAttribute("JDBMnger_login_19091991",getlogin);
            response.sendRedirect("index.jsp");
        //}
    }
    login = (String[])session.getAttribute("JDBMnger_login_19091991");
    if(login == null || login[2] ==null){
        out.write(h.login());
    }else{
    my.connect(login);
    //===============================================================================
  
    if((action+"_").equals("droptable_")){
     my.execsql("DROP TABLE "+db+"."+table);
     response.sendRedirect("index.jsp?db="+db);
    }
    if((action+"_").equals("addrowid_")){
     out.write("ALTER TABLE "+db+"."+table+" add rowid INT PRIMARY KEY AUTO_INCREMENT;");
     response.sendRedirect("index.jsp?db="+db+"&table="+table);
    }
    if((action+"_").equals("trunktable_")){
     my.execsql("TRUNCATE TABLE "+db+"."+table);
     response.sendRedirect("index.jsp?db="+db+"&table="+table);
    }
    if((action+"_").equals("delete_")){
     my.execsql("DELETE FROM "+db+"."+table+" WHERE "+key+"="+value+";");
     response.sendRedirect("index.jsp?db="+db+"&table="+table);
    }
    if((action+"_").equals("logout_")){
        request.getSession().invalidate();
        response.sendRedirect(request.getRequestURI());
    }
%>
<div id="databases" >
<div id="sort">
<a href="index.jsp"><img src="Images/home.png" alt="Home" ></a>
<a href="index.jsp?action=logout"><img src="Images/logout.png" alt="Logout" ></a>
</div>
<% out.write(my.getDBList());%>
</div>
<div id="body">
<div id="nav">
<ul id="arrow">
    <li><a href="index.jsp">Home</a></li>
        <% title = "Home"; %>
	<% if(db!=null){%>
    <li><a href="index.jsp?db=<%=db%>"><%=db%></a></li>
        <% title = db; %>
	<%}%>
	<% if(table!=null){%>
        <% title = table; %>
    <li><a href="index.jsp?db=<%=db%>&table=<%=table%>"><%=table%></a></li>
	<%}%>
</ul>
</div>
<ul class="tabs" data-persist="true">
	<li <%=h.tab(tab,"Home")%>><a href="index.jsp"><%=title%></a></li>
        <% if(db == null){ %>
	<li <%=h.tab(tab,"query")%>><a href="index.jsp?tab=query">Query</a></li>
        <% }else{ %>
	<li <%=h.tab(tab,"query")%>><a href="index.jsp?db=<%=db%>&tab=query">Query</a></li>
	<li <%=h.tab(tab,"export")%>><a href="export?db=<%=db%>">Export</a></li>
	<li <%=h.tab(tab,"import")%>><a href="index.jsp?db=<%=db%>&tab=import">Import</a></li>
        <% } %>
</ul>
<div id="table">
        <div id="ct">
        <%
        if(tab == "Home"){
        /* create database option */
        if(action == null){
            if((db == null) && (table == null)){
                %><form action="JDBMngr" method="post">Create Database&nbsp;&nbsp;<input type="text" name="database"/>&nbsp;&nbsp;<%
                 out.write(my.getCollation()); 
                %><input type="hidden" name="action" value="createdb"/>&nbsp;&nbsp;<input type="submit" value="Create"/></form><%
            }
        }
        /* list of tables */
        if(action == null){
            if((db != null) && (table == null)){
                %><!--a href="index.jsp?db=<%=db%>&action=createtable"><input type="submit" value="Create Table"/></a--><%
                out.write(my.getTList(db));
            }
        }
        /* get table */
        if(action == null){
            if((db != null) && (table != null)){
                my.setrowcount();
                out.write(h.getpagination());
                out.write(my.getTable(db,table));
            }
        }
        /* get table insert */
        if(((action+"_").equals("inserttable_"))){
            if((db != null) && (table != null)){out.write(my.inserttable(db,table));}
        }
        /* get table update */
        if(((action+"_").equals("update_"))){
            if((db != null) && (table != null)){out.write(my.updaterow(db,table,key,value));}
        }
        /* create table option */
        if((action+"_").equals("createtable_")){
            if(col == null){
                if((db != null) && (table == null)){out.write(my.getcolumnno());}
            }else{
                if((db != null) && (table == null)){out.write(my.createtable(db,Integer.parseInt(col)));}
            }
        }
    }
    if((tab+"_").equals("query_")){
        %>
                <form action="JDBMngr" method="post">
                    <textarea  id='codeArea' class='input' spellcheck='false' rows="20" cols="100" name="query"></textarea>
                    <br/>
                    <input type="hidden" name="database" value="<%=db%>" />
                    <input type="submit" name="execute" value="execute"/>
                </form>
        <%
    }
    if((tab+"_").equals("import_")){
        %>
		<input id="file" type="file" onchange="load()"/>
                <form action="JDBMngr" method="post">
                <input type="hidden" name="query" id="query" value="" />
                <input type="hidden" name="database" value="<%=db%>" />
                <input type="submit" name="execute" value="execute"/>
                </form>
        <%
    }
        %>
        </div>
</div>
</div>
</div>
<% 
    if(error != null){
        out.write(my.getERROR());
        out.write(h.poperror(error));
    }
}
%>
</body>
</html>
<%
    my = null; 
    h = null; 
%>
