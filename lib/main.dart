import 'dart:async';
import 'dart:convert';
import 'Yodo1Mas.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_games/store/AppStore.dart';
import 'package:mighty_games/store/WishListStore/WishListStore.dart';
import 'package:mighty_games/utils/Extensions/Commons.dart';
import 'package:mighty_games/utils/Extensions/Constants.dart';
import 'package:mighty_games/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_games/utils/Extensions/device_extensions.dart';
import 'package:mighty_games/utils/Extensions/shared_pref.dart';
import 'package:mighty_games/utils/Extensions/string_extensions.dart';
import 'package:mighty_games/utils/appWidget.dart';
import 'package:mighty_games/utils/colors.dart';
import 'package:mighty_games/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppTheme.dart';
import 'language/AppLocalizations.dart';
import 'language/BaseLanguage.dart';
import 'model/DashboardResponse.dart';
import 'model/LanguageDataModel.dart';
import 'screen/SplashScreen.dart';
import 'component/yodo1component.dart';

AppStore appStore = AppStore();
WishListStore wishListStore = WishListStore();
late SharedPreferences sharedPreferences;

Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal = primaryColor;

int passwordLengthGlobal = 6;
int mAdShowCount = 0;
int mAdCategoryViewAllShowCount = 0;
int mAdViewAllShowCount = 0;
final navigatorKey = GlobalKey<NavigatorState>();

late BaseLanguage language;
List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;

Future<void> initialize({
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  String wishListString = getStringAsync(WISHLIST_ITEM_LIST);
  if (wishListString.isNotEmpty) {
    wishListStore.addAllWishListItem(jsonDecode(wishListString).map<Category>((e) => Category.fromJson(e)).toList());
  }

  if (isMobile) {
    await OneSignal.shared.setAppId(mOneSignalID);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(DEFAULT_LANGUAGE);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
    startInitSdk();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      wishListStore.setConnectionState(e);
      if (e == ConnectivityResult.none) {
        log('not connected');
      } else {
        connectivitySubscription.cancel();
        log('connected');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        title: AppName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: DEFAULT_LANGUAGE)),
      );
    });
  }
}
