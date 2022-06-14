import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:uniestagios/screens/candidate_register/candidate_register_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/format_date.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';
import '../../../shared/csc_picker.dart';

import 'controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = Get.find<HomeController>();
  final controller = Get.find<CandidateRegisterController>();
  final _loading = Get.find<LoadingController>();
  String state = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    _homeController.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text(
              "Painel de Vagas",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Container(
                width: 60,
                child: FlatButton(
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => {
                    Get.bottomSheet(
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filtrar por cidade:',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              CSCPicker(
                                flagState: CountryFlag.DISABLE,
                                showStates: true,
                                showCities: true,
                                currentCountry: 'Brazil',
                                defaultCountry: DefaultCountry.Brasil,
                                dropdownDecoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey.shade500,
                                    width: 1,
                                  ),
                                ),
                                disabledDropdownDecoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                stateSearchPlaceholder: "Estado",
                                citySearchPlaceholder: "Cidade",
                                countryDropdownLabel: "País",
                                stateDropdownLabel: "Estado",
                                cityDropdownLabel: "Cidade",
                                layout: Layout.vertical,
                                disableCountry: true,
                                selectedItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                dropdownHeadingStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                onCountryChanged: (value) {
                                  setState(() {});
                                },
                                onStateChanged: (value) {
                                  state = value ?? '';
                                },
                                onCityChanged: (value) {
                                  city = value?.trim() ?? '';
                                  if (city == 'Cidade' || city == '') {
                                    print(city);
                                  } else {
                                    Get.back();
                                    _homeController.getJobsByCity(city);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      enableDrag: false,
                    ),
                  },
                ),
              ),
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Obx(() {
              if (_homeController.jobsList.isEmpty) {
                return const Center(
                  child: Text(
                    'Sem vagas por enquanto!',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _homeController.jobsList.length,
                itemBuilder: (context, index) {
                  if (_homeController.jobsList[index] == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  JobModel model = _homeController.jobsList[index]!;

                  String profilePic = model.profilePic == ''
                      ? 'https://firebasestorage.googleapis.com/v0/b/uniestagios-e460b.appspot.com/o/uploads%2Fplaceholder.jpeg?alt=media&token=aa90dd7a-44ae-4a8e-97dd-3a3ebe83318a'
                      : model.profilePic;

                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              profilePic,
                            ),
                          ),
                          title: Text(model.enterpriseName),
                          subtitle: Text(
                            formatDateToText(
                              context,
                              model.jobDate,
                            )!,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 10,
                            ),
                            child: Text(
                              model.jobName,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Image.network(
                            model.cvPic,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            height: 40,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      Get.dialog(
                                        AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Tem certeza que deseja se candidatar a esta vaga?',
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
                                                    MaterialStateProperty.all(
                                                        Colors.red),
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
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kPrimaryColor),
                                              ),
                                              child: const Text(
                                                'Sim',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                Get.back();
                                                if (model.cvPic == '') {
                                                  appWarningDialog(
                                                    title: 'Erro!',
                                                    middleText:
                                                        'Você precisa atualizar seu currículo, acesse Perfil > Currículo',
                                                  );
                                                }

                                                try {
                                                  _loading.on();
                                                  await controller
                                                      .registerJob(model);
                                                } finally {
                                                  _loading.out();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        barrierDismissible: false,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: kPrimaryColor,
                                    ),
                                    label: Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Text(
                                        'Enviar currículo',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
        Obx(
          () => Visibility(
            visible: _loading.status.value,
            child: const AppOverlay(),
          ),
        ),
      ],
    );
  }
}
