export class logInUtils {
  private md5 = require("md5");

  static encrypt(password: string, key: number){
    var i:number;
    var j:number;
    var hashedPass:string = "";
    for(i = 0; i <password.length; i++)
      for(j = password.charCodeAt(i) - key; j <= password.charCodeAt(i) + key; j++){
        hashedPass = hashedPass.concat(String.fromCharCode(j));
      }
    return hashedPass;
  }

  static decrypt(hashedPassword: string, key: number){
    var password:string = "";
    var i:number = key;
    for(i; i<hashedPassword.length; i = i + key*2+1)
      password = password.concat(hashedPassword.charAt(i));
    return password;
  }
}