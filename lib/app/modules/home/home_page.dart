import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mytodo_with_sqllite_flutter/app/modules/home/home_controller.dart';
import 'package:mytodo_with_sqllite_flutter/app/modules/new_task/new_task_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, controller, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Atividades",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: controller.listTodos?.keys?.length ?? 0,
                itemBuilder: (context, index) {
                  var dateFormat = DateFormat('dd/MM/yyyy');
                  var listTodos = controller.listTodos;
                  var dayKey = listTodos.keys.elementAt(index);
                  var day = dayKey;
                  var todos = listTodos[dayKey];

                  if (todos.isEmpty && controller.selectedTab == 0) {
                    return SizedBox.shrink();
                  }

                  var today = DateTime.now();
                  if (dayKey == dateFormat.format(today)) {
                    day = 'HOJE';
                  } else if (dayKey == dateFormat.format(today.add(Duration(days: 1)))) {
                    day = 'AMANHÃ';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              day,
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                            IconButton(
                              icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor, size: 30),
                              onPressed: () async {
                                await Navigator.of(context).pushNamed(NewTaskPage.routerName, arguments: dayKey);
                                controller.update();
                              },
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: todos.length,
                        itemBuilder: (_, index) {
                          var todo = todos[index];

                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: (){
                                  controller.delete(todo);
                                  controller.update();
                                },
                              ),
                            ],
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: Theme.of(context).primaryColor,
                                value: todo.finalizado,
                                onChanged: (bool value) => controller.checkedOrUncheck(todo),
                              ),
                              title: Text(
                                todo.descricao,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              trailing: Text(
                                '${todo.dataHora.hour.toString().padLeft(2,'0')}:${todo.dataHora.minute.toString().padLeft(2,'0')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
        bottomNavigationBar: FFNavigationBar(
          selectedIndex: controller.selectedTab,
          onSelectTab: (index) => controller.changeSeletedTab(context, index),
          items: [
            FFNavigationBarItem(
              iconData: Icons.check_circle,
              label: 'Finalizados',
            ),
            FFNavigationBarItem(
              iconData: Icons.view_week,
              label: 'Semanal',
            ),
            FFNavigationBarItem(
              iconData: Icons.calendar_today,
              label: 'Selecionar Data',
            ),
          ],
          theme: FFNavigationBarTheme(
            itemWidth: 60,
            barHeight: 70,
            barBackgroundColor: Theme.of(context).primaryColor,
            unselectedItemIconColor: Colors.white,
            unselectedItemLabelColor: Colors.white,
            selectedItemBorderColor: Colors.white,
            selectedItemIconColor: Colors.white,
            selectedItemBackgroundColor: Theme.of(context).primaryColor,
            selectedItemLabelColor: Colors.black,
          ),
        ),
      );
    });
  }
}
