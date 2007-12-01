var Location = Class.create();

Location.update = function(id, params)
{
  params = $H(params);
  console.log(params);
  $(id).style.backgroundColor = params.color;
  $(id+"_name").innerHTML = params.name;
  j$("#"+id+" .list").html(params.list);
};