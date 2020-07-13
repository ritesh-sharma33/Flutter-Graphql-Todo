import "package:flutter/material.dart";
import 'HomePage.dart';
import "package:graphql_flutter/graphql_flutter.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink(uri: "http://10.0.2.2:4000/");

    ValueNotifier<GraphQLClient> client =
        ValueNotifier(GraphQLClient(cache: InMemoryCache(), link: link));

    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          home: HomePage(),
        ));
  }
}
