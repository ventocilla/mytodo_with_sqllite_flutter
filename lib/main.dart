import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytodo_with_sqllite_flutter/app/database/connection.dart';
import 'package:mytodo_with_sqllite_flutter/app/modules/home/home_controller.dart';
import 'package:mytodo_with_sqllite_flutter/app/modules/new_task/new_task_controller.dart';
import 'package:mytodo_with_sqllite_flutter/app/modules/new_task/new_task_page.dart';
import 'package:mytodo_with_sqllite_flutter/app/repositories/todos_repository.dart';
import 'package:provider/provider.dart';
import 'app/database/database_admin_connection.dart';
import 'app/modules/home/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  DataBaseAdmConnection dataBaseAdmConnection = DataBaseAdmConnection();

  @override
  void initState() {
    Connection().instance;
    super.initState();
    WidgetsBinding.instance.addObserver(dataBaseAdmConnection);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(dataBaseAdmConnection);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TodosRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyTodo',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9129),
          buttonColor: Color(0xFFFF9129),
          textTheme: GoogleFonts.robotoTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          NewTaskPage.routerName: (_) => ChangeNotifierProvider(
                create: (context) {
                  var day = ModalRoute.of(_).settings.arguments;
                  return NewTaskController(repository: context.read<TodosRepository>(), day: day);
                },
                child: NewTaskPage(),
              ),
        },
        home: ChangeNotifierProvider(
          create: (context) {
            // ! Antes da 4.1 ..
            //var repository = Provider.of<TodosRepository>(context);
            // ! Depois da 4.1 ...
            var repository = context.read<TodosRepository>();
            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
