//import 'dart:ffi';
//sssssss
import 'dart:io';
int choice()
{
  int? ch;
  print("TO READ DATA    PRESS (1) : ");
  print("TO DISPLAY DATA PRESS (2) : ");
  print("TO EXIT         PRESS (3) : ");
  ch = int.parse(stdin.readLineSync()!);
  return ch;
}
//111
class patiant {
  String? _username;
  String? _password;
  void read()
  {
    print("Enter your Name : ");
    _username = stdin.readLineSync();
    print("Enter your Age : ");
    _password = stdin.readLineSync(); 
  }
  void display()
  {
    print("your Name : $_username");
    print("your Age : $_password");
  }
}
void main()
{
  patiant p = patiant();
  int ch=0;
  while (ch!=3) {
    ch=choice();
    switch (ch) {
      case 1:
        p.read();
        break;
      case 2:
        p.display();
        break;
      case 3:
        print("Thank You For Your Time :)");
        break;
      default:
      print("WRONG INPUT!!!");
        break;
    }
  }
}