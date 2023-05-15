# todo_app_new_edition

A new Flutter project.  

[The advantages of Flutter](https://www.zhihu.com/question/485739670/answer/2950106277)  

## Getting Started

### Description and main functions  

[The planning design of app](https://github.com/cn666278/task-todo-new-edition/blob/main/FYP_Final.edited.docx)  

[Main functions design](https://github.com/cn666278/task-todo-new-edition/blob/main/Flutter%20Project%20Note.docx)  

### Run the code
1. Turn off all anti-virus software, personal hot spots
2. Open the project file using Android Studio
3. Run Flutter Doctor to ensure the required runtime configuration
4. Link to your devices(virtual machine or physical machine)
5. Running the project   

### Prototype (GUI design)
[![N|Solid](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](https://www.figma.com/proto/uJzJKBsqYq6PJWWApKvH8D/Task-todo-app?node-id=204%3A1086&scaling=scale-down&page-id=0%3A1&starting-point-node-id=204%3A1086&show-proto-sidebar=1)  

### Database
`Sqflite` is a lightweight relational database, similar to `SQLite` in iOS and Android  

[SQFLite](https://www.jianshu.com/p/e1a0fb3d202a)

`MySQL+XAMPP`
1. start the MySQL service  
```
cmd -> net start mysql 
```
2. open XAMPP start Apache and MySQL

3. click the admin in XAMPP

4. Enter the http://localhost/phpmyadmin/ page  
5. make php file in C:\xampp\htdocs\dashboard  
  
  
Dart API Package:  
1. [mysql1](https://pub.flutter-io.cn/packages/mysql1)  
2. [mysql_utils](https://pub.flutter-io.cn/packages/mysql_utils)  
  
[Edit your password in MySQL database](https://blog.csdn.net/qq_52487066/article/details/127009665)  

[Flutter Error: Cannot run with sound null safety](https://zhuanlan.zhihu.com/p/405838959)  

[ERROR 1396 (HY000): Operation ALTER USER failed for ‘root‘@‘localhost‘](https://blog.csdn.net/q258523454/article/details/84555847)  


## Others
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [XMUX Technology reference](https://docs.xmux.xdea.io/developer/architecture/)  
- [XMUX](https://github.com/XMUMY/XMUX)  

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## README.md References:
1. [Shopify-flutter-demo/README.md design](https://github.com/mehulmk/Shopify-flutter-demo/tree/main)
