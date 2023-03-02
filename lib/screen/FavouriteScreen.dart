import 'dart:io';
import 'package:mighty_games/component/ItemWidget.dart';
import 'package:mighty_games/main.dart';
import 'package:mighty_games/screen/WebViewScreen.dart';
import 'package:mighty_games/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_games/utils/appWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/DashboardResponse.dart';

class FavouriteScreen extends StatefulWidget {
  static String tag = '/FavouriteScreen';

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> {
  List<Category>? mList;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    mList = wishListStore.wishList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(language.lblFavourite),
      body: Observer(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wishListStore.wishList.isNotEmpty
                ? SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Wrap(
                      runSpacing: 16,
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        wishListStore.wishList.length,
                        (index) {
                          Category data = wishListStore.wishList[index];
                          return AnimationConfiguration.staggeredGrid(
                            duration: const Duration(milliseconds: 750),
                            columnCount: 1,
                            position: index,
                            child: ItemWidget(
                              data,
                              isFavourite: true,
                              onTap: () async {
                                if (Platform.isAndroid) {
                                  if (data.url!.contains("market://") || data.url!.contains("play.google.com")) {
                                    await launchUrl(Uri.parse(data.url!));
                                  } else {
                                    WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                                  }
                                } else {
                                  WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ).expand()
                : noDataWidget(context).expand(),
          ],
        );
      }),
    );
  }
}
