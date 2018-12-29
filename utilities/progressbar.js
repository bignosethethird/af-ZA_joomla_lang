function includeCSS(p_file) {
  var v_css  = document.createElement('link');
  v_css.rel = 'stylesheet'
  v_css.type = 'text/css';
  v_css.href = p_file;
  document.getElementsByTagName('head')[0].appendChild(v_css);
}

var mInterval;

function startProgressBar() {
  reset();
  mInterval = setInterval("doProgress()",10);
}

function reset() {
  document.getElementById("mask").style.left = "0px";
  document.getElementById("mask").style.width = document.getElementById("mContainer").offsetWidth + "px";
  document.getElementById("progressIndicator").style.zIndex  = 10;
  document.getElementById("mask").style.display = "block";
  document.getElementById("progressIndicator").innerHTML = "0%";
}

function doProgress() {
  curWidth = parseInt(document.getElementById("mask").offsetWidth);
  curLeft = parseInt(document.getElementById("mask").offsetLeft);
  curWidth --;
  curLeft ++;

  if(curLeft ==561) {
    clearInterval(mInterval);
    document.getElementById("mask").style.display = "none";
    return;
  }


  document.getElementById("mask").style.left = curLeft + "px";
  if(parseInt(document.getElementById("mask").offsetWidth)>10)document.getElementById("mask").style.width = curWidth + "px";
  document.getElementById("progressIndicator").innerHTML = Math.floor((curLeft / parseInt(document.getElementById("gradient").offsetWidth))*100) + "%";

    if(Math.floor((curLeft / parseInt(document.getElementById("gradient").offsetWidth))*100)>45){
      clearInterval(mInterval);
    }

}
