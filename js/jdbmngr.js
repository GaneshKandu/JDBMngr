/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function href(){
    var a = document.getElementById('create_tb');
    var c = document.getElementById('columnno').value;
    a.href = "index.jsp?db=joomla&action=createtable&column="+c;
}
