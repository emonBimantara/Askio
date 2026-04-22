import 'package:askio/Features/Auth/Controller/auth_controller.dart';
import 'package:get/get.dart';
import '../Services/quiz_service.dart'; 

class HistoryController extends GetxController {
  final QuizService _quizService = QuizService(); 
  
  final AuthController _authController = Get.find<AuthController>();

  var isLoading = true.obs;
  var historyList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    try {
      isLoading.value = true;
      String? userId = _authController.user?.uid;
      
      if (userId != null) {
        var data = await _quizService.getQuizHistory(userId);
        historyList.assignAll(data);
      }
    } catch (e) {
      print("Failed to fetch history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}