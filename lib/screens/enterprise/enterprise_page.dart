import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:uniestagios/screens/enterprise/enterprise_controller.dart';
import 'package:uniestagios/screens/home/controllers/home_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/format_date.dart';
import 'package:uniestagios/utils/groupby.dart';
import 'package:uniestagios/utils/overlay.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  final _enterpriseController = Get.find<EnterpriseController>();
  final _homeController = Get.find<HomeController>();
  final _loading = Get.find<LoadingController>();
  late JobModel model;
  String profilePic = '';

  @override
  void initState() {
    super.initState();
    _homeController.getEnterpriseJobs();
  }

  void edit(JobModel model) async {
    await Future.delayed(const Duration(milliseconds: 10));
    Get.toNamed('/jobRegister', arguments: model);
  }

  void remove(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Tem certeza que deseja remover essa vaga?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              'Não',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            ),
            child: const Text(
              'Sim',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Get.back();
              try {
                _loading.on();
                await _enterpriseController.removeJob(id).then((value) {
                  Get.dialog(
                    AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Vaga removida com sucesso!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                          ),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            _homeController.getEnterpriseJobs();
                          },
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                });
              } finally {
                _loading.out();
              }
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void updateAvailable(String id, bool available) async {
    await Future.delayed(const Duration(milliseconds: 10));
    String text = available ? 'finalizar' : 'reabrir';
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tem certeza que deseja $text essa vaga?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              'Não',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            ),
            child: const Text(
              'Sim',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Get.back();
              try {
                _loading.on();
                await _enterpriseController
                    .updateJobAvailable(id, available ? false : true)
                    .then((value) {
                  Get.dialog(
                    AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            !available
                                ? 'Vagas abertas! '
                                : 'Vaga finalizada! Você ainda pode reabrir a vaga no menu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                          ),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            _homeController.getEnterpriseJobs();
                          },
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                });
              } finally {
                _loading.out();
              }
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('Minhas vagas'),
            automaticallyImplyLeading: false,
          ),
          body: Obx(() {
            final groupList = _homeController.jobsList.groupBy((e) {
              if (e != null) {
                model = e;
                profilePic = e.profilePic == ''
                    ? 'https://firebasestorage.googleapis.com/v0/b/uniestagios-e460b.appspot.com/o/uploads%2Fplaceholder.jpeg?alt=media&token=aa90dd7a-44ae-4a8e-97dd-3a3ebe83318a'
                    : e.profilePic;
              }
              return model.available;
            });

            if (groupList.isEmpty) {
              return Center(
                child: Text(
                  'Sem vagas por enquanto!',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  children: groupList
                      .map(
                        (key, value) => MapEntry(
                          key,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Vagas ${key ? 'abertas: ' : 'encerradas: '}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ...value
                                  .map(
                                    (e) => Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Container(
                                              width: 40,
                                              height: 40,
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    profilePic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(e!.enterpriseName),
                                            subtitle: Text(
                                              formatDateToText(
                                                context,
                                                e.jobDate,
                                              )!,
                                            ),
                                            trailing: PopupMenuButton(
                                              icon: Icon(Icons.more_vert),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: Text("Editar"),
                                                  value: 1,
                                                  onTap: () {
                                                    edit(e);
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  child: Text("Excluir"),
                                                  value: 2,
                                                  onTap: () {
                                                    remove(e.id);
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  child: Text(
                                                    e.available
                                                        ? "Vaga Finalizada"
                                                        : "Vagas abertas",
                                                  ),
                                                  value: 3,
                                                  onTap: () {
                                                    updateAvailable(
                                                        e.id, e.available);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Image.network(
                                            e.cvPic,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    e.jobName,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Área de atuação: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${e.jobArea[0].toUpperCase()}${e.jobArea.substring(1).toLowerCase()}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
            );
            // );

            // if (_homeController.jobsList.isEmpty) {
            // return const Center(
            //   child: Text(
            //     'Sem vagas por enquanto!',
            //     style: TextStyle(
            //       color: kPrimaryColor,
            //       fontSize: 18,
            //     ),
            //   ),
            // );
            // }

            // return ListView.builder(
            //   itemCount: _homeController.jobsList.length,
            //   itemBuilder: (context, index) {
            // if (_homeController.jobsList[index] == null) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            // JobModel model = _homeController.jobsList[index]!;

            // String profilePic = model.profilePic == ''
            //     ? 'https://firebasestorage.googleapis.com/v0/b/uniestagios-e460b.appspot.com/o/uploads%2Fplaceholder.jpeg?alt=media&token=aa90dd7a-44ae-4a8e-97dd-3a3ebe83318a'
            //     : model.profilePic;

            //     return Card(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: <Widget>[
            //           ListTile(
            //             leading: Container(
            //               width: 40,
            //               height: 40,
            //               padding: EdgeInsets.zero,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 image: DecorationImage(
            //                   fit: BoxFit.fill,
            //                   image: NetworkImage(
            //                     profilePic,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             title: Text(model.enterpriseName),
            //             subtitle: Text(
            //               formatDateToText(
            //                 context,
            //                 model.jobDate,
            //               )!,
            //             ),
            //             trailing: PopupMenuButton(
            //               icon: Icon(Icons.more_vert),
            //               itemBuilder: (context) => [
            //                 PopupMenuItem(
            //                   child: Text("Editar"),
            //                   value: 1,
            //                   onTap: () {
            //                     edit(model);
            //                   },
            //                 ),
            //                 PopupMenuItem(
            //                   child: Text("Excluir"),
            //                   value: 2,
            //                   onTap: () {
            //                     remove(model.id);
            //                   },
            //                 ),
            //                 PopupMenuItem(
            //                   child: Text(
            //                     model.available
            //                         ? "Vaga Finalizada"
            //                         : "Vagas abertas",
            //                   ),
            //                   value: 3,
            //                   onTap: () {
            //                     updateAvailable(model.id, model.available);
            //                   },
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Image.network(
            //             model.cvPic,
            //           ),
            //           Align(
            //             alignment: Alignment.topLeft,
            //             child: Padding(
            //               padding: EdgeInsets.symmetric(
            //                 horizontal: 10,
            //                 vertical: 20,
            //               ),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     model.jobName,
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w700,
            //                     ),
            //                   ),
            //                   SizedBox(height: 10),
            //                   RichText(
            //                     text: TextSpan(
            //                       text: 'Área de atuação: ',
            //                       style: TextStyle(
            //                         color: Colors.black,
            //                         fontSize: 16,
            //                       ),
            //                       children: [
            //                         TextSpan(
            //                           text:
            //                               '${model.jobArea[0].toUpperCase()}${model.jobArea.substring(1).toLowerCase()}',
            //                           style: TextStyle(
            //                             color: Colors.black,
            //                             fontSize: 16,
            //                             fontWeight: FontWeight.w700,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           model.available
            //               ? Container()
            //               : Padding(
            //                   padding: const EdgeInsets.only(
            //                     left: 10,
            //                     bottom: 10,
            //                   ),
            //                   child: Row(
            //                     children: [
            //                       Container(
            //                         decoration: BoxDecoration(
            //                           shape: BoxShape.circle,
            //                           color: Colors.red,
            //                         ),
            //                         width: 16,
            //                         height: 16,
            //                       ),
            //                       SizedBox(width: 5),
            //                       Text(
            //                         'Vagas encerradas',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //         ],
            //       ),
            //     );
            //   },
            // );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/jobRegister');
            },
            child: Icon(
              Icons.add,
            ),
            backgroundColor: kSecondaryColor,
          ),
        ),
        Obx(
          () => Visibility(
            visible: _loading.status.value,
            child: AppOverlay(),
          ),
        ),
      ],
    );
  }
}
