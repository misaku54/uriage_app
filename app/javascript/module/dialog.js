function check(){
  if(window.confirm('本当に削除しますか？')){ 
    return true;
  }
  else{
    window.alert('キャンセルされました'); 
    return false; 
  }
}
console.log('aaa');