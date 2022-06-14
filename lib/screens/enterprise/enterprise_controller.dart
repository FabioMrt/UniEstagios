import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/data/firebase/candidate/firebase_candidate_data.dart';
import 'package:uniestagios/data/firebase/job/firebase_job_data.dart';
import 'package:uniestagios/models/candidate_model.dart';
import 'package:uniestagios/models/enterprise_model.dart';
import 'package:uniestagios/models/job_model.dart';

class EnterpriseController extends GetxController {
  final _userController = Get.find<UserController>();
  final _firebaseCandidate = FirebaseCandidateData();
  final _firebaseJobData = FirebaseJobData();

  var candidatesList = <CandidateModel>[].obs;

  Future<EnterpriseModel> getJobs() async {
    final user = await _userController.getCurrentEnterprise();
    return user;
  }

  Future<List<CandidateModel>> getCandidates() async {
    final user = await _userController.getCurrentEnterprise();
    candidatesList.value =
        await _firebaseCandidate.getEnterpriseCandidates(user.id ?? '');
    return candidatesList;
  }

  Future removeJob(String id) async {
    await _firebaseJobData.removeJob(id);
  }

  Future updateJobAvailable(String id, bool available) async {
    await _firebaseJobData.updateJobAvailable(id, available);
  }
}
