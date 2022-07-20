import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shiro_bot/screens/Auth/controller/db_controller.dart';
import 'package:shiro_bot/screens/Auth/model/user_model.dart';
import 'package:shiro_bot/screens/Auth/view/auth_page.dart';
import 'package:shiro_bot/screens/Home/controller/home_controller.dart';
import 'package:shiro_bot/screens/Home/view/home_page.dart';
import 'package:shiro_bot/utils/util_function.dart';

class userProvider extends ChangeNotifier {
  final DatabaseController _databaseController = DatabaseController();
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  //initialize user function
  Future<void> initializerUser(BuildContext context) async {
    Provider.of<HomeController>(context, listen: false)
        .chechBlutoothOn(context);
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Logger().w('User is currently signed out');
        UtilFunction.navigateTo(context, AuthPage());
      } else {
        //  name = user.email;
        print(user.uid);
        print(user.email);

        Logger().w('User is signed in');
        UtilFunction.navigateTo(context, HomePage());
        await fetchSingleUser(user.uid);
      }
    });
  }

  Future<void> fetchSingleUser(String id) async {
    _userModel = (await _databaseController.getuserData(id))!;
    notifyListeners();
  }
}
