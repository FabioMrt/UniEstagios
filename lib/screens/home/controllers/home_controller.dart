import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/data/firebase/job/firebase_job_data.dart';
import 'package:uniestagios/models/job_model.dart';

class HomeController extends GetxController {
  final _firebaseJob = FirebaseJobData();
  final _userController = Get.find<UserController>();

  var jobsList = <JobModel?>[].obs;

  Future<List<JobModel?>> getJobs() async {
    final user = await _userController.getCurrentIntern();
    jobsList.value = await _firebaseJob.getJobsByCity(user.city ?? "");
    return jobsList;
  }

  Future<List<JobModel?>> getEnterpriseJobs() async {
    final user = await _userController.getCurrentEnterprise();
    jobsList.value = await _firebaseJob.getEnterpriseJobs(user.id ?? "");
    return jobsList;
  }

  Future<List<JobModel?>> getJobsByCity(String city) async {
    jobsList.value = await _firebaseJob.getJobsByCity(city);
    return jobsList;
  }
}
