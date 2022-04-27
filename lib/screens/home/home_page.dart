import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/format_date.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _homeController.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Painel de Vagas",
          style: TextStyle(
            color: kPrimaryColor,
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
        child: Obx(() {
          return ListView.builder(
            itemCount: _homeController.jobsList.length,
            itemBuilder: (context, index) {
              JobModel model = _homeController.jobsList[index];

              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          model.profilePic,
                        ),
                      ),
                      title: Text(model.enterpriseName),
                      subtitle: Text(
                        formatDateToText(
                          context,
                          model.jobDate,
                        )!,
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                    Container(
                      child: Image.network(
                        model.cvPic,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          model.jobDescription,
                        ),
                      ),
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
            },
          );
        }),
      ),
    );
  }
}
