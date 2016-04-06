function dialogbox(t,m){
      var alert = document.createElement("div");
	  alert.setAttribute("id", "alert");
      var close = document.createElement("p");
	  close.setAttribute("id", "close");
	  close.setAttribute("style", "float:right");
      var a = document.createElement("a");
	  a.setAttribute("href", "#");
	  a.setAttribute("onclick", "dialogboxhide()");
      a.appendChild(document.createTextNode("X"));
	  close.appendChild(a);
      var title = document.createElement("div");
	  title.setAttribute("id", "dtitle");
	  alert.appendChild(title);
      var tit = document.createElement("p");
      tit.appendChild(document.createTextNode(t));
      tit.appendChild(close);
	  title.appendChild(tit);
      var body = document.createElement("div");
      body.appendChild(document.createTextNode(m));
	  alert.appendChild(body);
	  body.setAttribute("id", "errorbody");
      document.body.appendChild(alert);
}
function dialogboxhide() {
	var element = document.getElementById("alert");
	element.parentNode.removeChild(element);
}