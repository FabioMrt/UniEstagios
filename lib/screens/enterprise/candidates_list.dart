import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/screens/enterprise/enterprise_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/groupby.dart';

class CandidatesList extends StatefulWidget {
  const CandidatesList({Key? key}) : super(key: key);

  @override
  State<CandidatesList> createState() => _CandidatesListState();
}

class _CandidatesListState extends State<CandidatesList> {
  final _enterpriseController = Get.find<EnterpriseController>();

  @override
  void initState() {
    super.initState();
    _enterpriseController.getCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Lista de Candidatos'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (_enterpriseController.candidatesList.isEmpty) {
          return Center(
            child: Text(
              'Lista de candidatos vazia',
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
              horizontal: 10,
              vertical: 30,
            ),
            child: Obx(() {
              final groupList = _enterpriseController.candidatesList
                  .groupBy((candidate) => candidate.jobTitle);

              return Column(
                children: groupList
                    .map(
                      (key, value) => MapEntry(
                        key,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vaga: $key',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            ...value
                                .map(
                                  (e) => Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(e
                                                          .internImage ==
                                                      ''
                                                  ? 'https://firebasestorage.googleapis.com/v0/b/uniestagios-e460b.appspot.com/o/uploads%2Fplaceholder.jpeg?alt=media&token=aa90dd7a-44ae-4a8e-97dd-3a3ebe83318a'
                                                  : e.internImage),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          e.internName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.internEmail,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${e.internUniversity} | ${e.internCity}',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            e.answered == false
                                                ? Container()
                                                : Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.green,
                                                        ),
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Respondido',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        trailing: ElevatedButton(
                                          child: Text(
                                            'Ver currículo',
                                          ),
                                          onPressed: () {
                                            Get.toNamed('/candidateView',
                                                arguments: e);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: kSecondaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                )
                                .toList()
                          ],
                        ),
                      ),
                    )
                    .values
                    .toList(),
              );
            }),
          ),
        );
      }),
    );
  }
}
