function pageChange(url, param) {
    var target = "_self";
    if(param == undefined) {
        return;
    }
    
    var form = document.createElement("form"); 
    form.name = "dataform";
    form.action = url;
    form.method = "post";
    form.target = target;

    for(var name in param){
        var item = name;
        var val = "";
        if(param[name] instanceof Object){
            val = JSON.stringify(param[name]);
        } else {
            val = param[name];
        }
        
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = item;
        input.value = val;
        form.insertBefore(input, null);
    }

    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}