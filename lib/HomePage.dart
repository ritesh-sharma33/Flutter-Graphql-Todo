import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_graphql/CreateTodoPage.dart';
import 'package:todo_graphql/UsersPage.dart';

class HomePage extends StatelessWidget {
  final String fetchTodos = """
    query {
      todos {
        id
        title
        description
        createTime
        deadline
        createdBy {
          id
          name
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Manager"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.supervised_user_circle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UsersPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateTodoPage("", "", "", "")));
        },
      ),
      body: Container(
          child: Query(
        options: QueryOptions(documentNode: gql(fetchTodos)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List todos = result.data['todos'];

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ExpansionTile(
                title: Text(
                  todo['title'],
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(todo['description'].toString()),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Chip(
                              avatar: Icon(Icons.timer),
                              label: Text(todo['createTime']),
                            ),
                            Chip(
                              avatar: Icon(Icons.av_timer),
                              label: Text(todo['deadline']),
                            ),
                          ],
                        ),
                        Center(
                          child: Chip(
                            label: Text(todo['createdBy']['name']),
                            avatar: Icon(Icons.account_circle),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Row(
                                children: [Icon(Icons.edit), Text("Edit Todo")],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateTodoPage(
                                          todo['id'],
                                          todo['title'],
                                          todo['description'],
                                          todo['deadline']),
                                    ));
                              },
                            ),
                            FlatButton(
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  Text("Delete Todo")
                                ],
                              ),
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      )),
    );
  }
}
