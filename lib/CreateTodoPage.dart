import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_graphql/HomePage.dart';
import 'dart:math' as math;

class CreateTodoPage extends StatefulWidget {
  var id, title, description, deadline;

  CreateTodoPage(this.id, this.title, this.description, this.deadline);

  @override
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  String updateTodo = """
    mutation UpdateTodo(\$id: ID!, \$data: UpdateTodoInput!) {
      action: updateTodo(id: \$id, data: \$data) {
        id
        title
        description
        createTime
        deadline
        createdBy {
          name
          email
        }
      }
    }
  """;

  String createTodo = """
    mutation CreateTodo(\$data: CreateTodoInput!) {
      action: createTodo(data: \$data) {
        id
        title
        description
        createTime
        deadline
        createdBy {
          id
          name
          email
        }
      }
    }
  """;

  TextEditingController titleController, descController, deadlineController;

  String generateRandomUser() {
    math.Random rnd = new math.Random();
    int userId = 11 + rnd.nextInt(13);
    return userId.toString();
  }

  @override
  void initState() {
    titleController = new TextEditingController(text: widget.title);
    descController = new TextEditingController(text: widget.description);
    deadlineController = new TextEditingController(text: widget.deadline);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Title: ${widget.title}");
    print("Description: ${widget.description}");
    print("Deadline: ${widget.title}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Create/Update Todo"),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: "Enter title here", labelText: "Title"),
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                    hintText: "Enter description here",
                    labelText: "Description"),
              ),
              TextFormField(
                controller: deadlineController,
                decoration: InputDecoration(
                    hintText: "Enter deadline here", labelText: "Deadline"),
              ),
              SizedBox(
                height: 20,
              ),
              Mutation(
                options: MutationOptions(
                    documentNode:
                        widget.title == "" ? gql(createTodo) : gql(updateTodo),
                    onCompleted: (dynamic resultData) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }),
                builder: (RunMutation runMutation, QueryResult result) {
                  return RaisedButton(
                    child: Text(
                        widget.title == "" ? "Create Todo" : "Update Todo"),
                    onPressed: () {
                      if (widget.title == "") {
                        runMutation({
                          'data': {
                            'title': titleController.text,
                            'description': descController.text,
                            'createTime': DateTime.now().toString(),
                            'deadline': deadlineController.text,
                            'createdBy': generateRandomUser()
                          }
                        });
                      } else {
                        runMutation({
                          'id': widget.id,
                          'data': {
                            'title': titleController.text,
                            'description': descController.text,
                            'deadline': deadlineController.text
                          }
                        });
                      }
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}
