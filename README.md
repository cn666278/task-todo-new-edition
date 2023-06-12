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
- [Rive](https://www.rive.app/)  

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## User Hanbook
### 0. demo
<img src="screenshots/demo.gif" width="800px"/>   

### 1. All Tasks page

Progress logic(on the uper right corner):
```
progress(%) = completed tasks / all tasks
```

<img src="screenshots/all task page/all task 1.png" height="450px" /> <img src="screenshots/all task page/alltask2.png" height="450px" /> <img src="screenshots/all task page/all task 3.png" height="450px" />

### 2. Calendar page
<img src="screenshots/Calendar Page/c1.png" height="450px" /> <img src="screenshots/Calendar Page/c2.png" height="450px" />

### 3. Highlights page

Progress logic(on the uper right corner):
```
progress(%) = completed star tasks / all star tasks
```

<img src="screenshots/Highlight Page/h1.png" height="450px" /> <img src="screenshots/Highlight Page/h2.png" height="450px" /> <img src="screenshots/Highlight Page/h3.png" height="450px" />

### 4. Report page

Report logic:
```
efficiency(%) = completed tasks / all tasks
```

<img src="screenshots/Report Page/r1.png" height="420px" /> <img src="screenshots/Report Page/r2.png" height="420px" /> <img src="screenshots/Report Page/r3.png" height="420px" /> <img src="screenshots/Report Page/r4.png" height="420px" /> 

Click the button on the uper right corner to change the style of displaying.  

<img src="screenshots/Report Page/r1.png" height="450px" /> <img src="screenshots/Report Page/r6.png" height="450px" /> <img src="screenshots/Report Page/r5.png" height="450px" />

### 5. Task Details

You can see all the task details by clicking the `Details` button in the corresponding task (the bottom bar of the pop-up below), and you can freely modify the content of the task, and finally update the current task content through the `Update Task` button.

<img src="screenshots/Detail page/ss1.png" height="450px" /> <img src="screenshots/Detail page/detail.png" height="450px" />

### 6. Task Completed

You can edit the state of task by clicking the `Task Completed` or `Undo Completed` button in the corresponding task (the bottom bar pops up below), and the status of the task(`TODO` or `COMPLETED`) will be displayed on the far right of the task card when the modification is completed.  

<img src="screenshots/Task complted/ss1.png" height="450px" /> <img src="screenshots/Task complted/ssundo.png" height="450px" /> <img src="screenshots/Task complted/after complted.png" height="450px" />

### 7. Star Task

You can set the priority of our task by right silding on our task card (by `Star` or `Undo Star`). The task set as 'Star Task' will have a star added to the top left corner of the task card and displayed in the Highlights page.

<img src="screenshots/s3.png" height="450px" /> <img src="screenshots/s4.png" height="450px" /> 

### 8. Sile bar menu  
<img src="screenshots/s8.png" height="450px" /> 

### 9. Search tasks  
<img src="screenshots/Search Task/s8.png" height="420px" /> <img src="screenshots/Search Task/sss1.png" height="420px" /> <img src="screenshots/Search Task/sss2.png" height="420px" /> <img src="screenshots/Search Task/s9.png" height="420px" />  

### 10. Theme Mode Switch    
<img src="screenshots/Drak Mode/all task 1.png" height="420px" /> <img src="screenshots/Drak Mode/d2.png" height="420px" /> <img src="screenshots/Drak Mode/d3.png" height="420px" /> <img src="screenshots/Drak Mode/d5.png" height="420px" />  

## README.md References
1. [Shopify-flutter-demo/README.md design](https://github.com/mehulmk/Shopify-flutter-demo/tree/main)

## License
This project is licensed under the GPLv3 License - see the LICENSE.md file for details.
