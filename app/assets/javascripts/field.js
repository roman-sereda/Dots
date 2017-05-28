$(document).ready(function(){

  var field = document.getElementById("field")

  field.addEventListener("click", getPosition, false);

  for(var i = 0; i < 20; i++){
    var ctx = field.getContext("2d");

    ctx.lineWidth = 1
    ctx.moveTo(20 * i - 1, 0);
    ctx.lineTo(20 * i - 1, 400);
    ctx.stroke();
  }

  for(var i = 0; i < 20; i++){
    var ctx = field.getContext("2d");

    ctx.lineWidth = 1
    ctx.moveTo(0, 20 * i - 1);
    ctx.lineTo(400, 20 * i - 1);
    ctx.stroke();
  }

});

function getPosition(event){
  var rect = field.getBoundingClientRect();
  var x = event.clientX - rect.left;
  var y = event.clientY - rect.top;
  console.log("x: " + x + " y: " + y);

  putPoint(x,y)
}

function putPoint(x,y){
  var point = field.getContext('2d');
  if(( x / 20 - ~~( x / 20 )) > 0.5){
    x = 20 * ~~(x / 20 + 1)
  }else{
    x = 20 * ~~(x / 20)
  };

  if(( y / 20 - ~~( y / 20 )) > 0.5){
    y = 20 * ~~(y / 20 + 1)
  }else{
    y = 20 * ~~(y / 20)
  };

  point.beginPath();
  point.arc(x, y, 7, 0, 2*Math.PI, false);
  point.fillStyle = 'red';
  point.fill();
  point.lineWidth = 1;
  point.strokeStyle = 'red';
  point.stroke();

  checkForZones()
}

function checkForZones(){

}
