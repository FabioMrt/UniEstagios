import 'package:flutter/material.dart';
import 'package:uniestagios/screens/infovaga/info_vaga.dart';
import 'package:uniestagios/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: SizedBox(
            width: 100,
            child: Title(
              color: kPrimaryColor,
              child: Text("Painel de Vagas"),
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            width: 60,
            child: FlatButton(
              child: Icon(
                Icons.filter_alt_outlined,
                color: Color.fromARGB(255, 76, 75, 75),
              ),
              onPressed: () => {},
            ),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 236, 230, 230),
        child: ListView(
          children: <Widget>[
            cardItem(),
            cardItem(),
            cardItem(),
            cardItem(),
            cardItem(),
            cardItem(),
          ],
        ),
      ),
    );
  }
}

Widget cardItem() {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.rededompedro.com/images/site/315f4093c038abbeb5b387e2772ee6d2.png"),
          ),
          title: Text("E MESMO"),
          subtitle: Text("dd/mm/aaaa  hh:mm"),
          trailing: Icon(Icons.more_vert),
        ),
        Container(
            //padding
            child: Image.asset("images/vaga02.jpeg")),
        Container(
          padding: EdgeInsets.all(10),
          child:
              Text("Vagas para desenvolvedor júnior/pleno na stack javascript"),
        ),
        ButtonTheme(
            child: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.info_outline, color: kPrimaryColor),
              onPressed: () {
                ;
              },
            ),
            FlatButton(
              child: Icon(Icons.share, color: kPrimaryColor),
              onPressed: () {/* .... */},
            ),
          ],
        ))
      ],
    ),
  );
}
