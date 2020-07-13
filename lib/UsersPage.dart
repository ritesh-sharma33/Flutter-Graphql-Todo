import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final String fetchUsers = """
    query {
      users {
        id
        name
        email
        todos {
          id
          title
          description
        }
      }
    }
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
      ),
      body: Container(
        child: Query(
            options: QueryOptions(documentNode: gql(fetchUsers)),
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

              List users = result.data['users'];
              print(users);

              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                      trailing: Chip(
                        label: Text(user['todos'].length.toString()),
                        avatar: Icon(
                          Icons.mode_edit,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
