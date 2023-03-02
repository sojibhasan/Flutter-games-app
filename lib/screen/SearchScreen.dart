import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mighty_games/component/ItemWidget.dart';
import 'package:mighty_games/model/DashboardResponse.dart';
import 'package:mighty_games/network/RestApis.dart';
import 'package:mighty_games/utils/Extensions/string_extensions.dart';
import 'package:mighty_games/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_games/utils/appWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/constant.dart';
import 'WebViewScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCont = TextEditingController();
  List<Category> games = [];
  List<Category> searchList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    loadGames();
  }

  void loadGames() {
    getGames().then((value) {
      games = value;
      if (searchCont.text.isNotEmpty) {
        searchList.clear();
        for (int i = 0; i <= searchCont.text.length; i++) {
          String data = games[i].name.validate();
          if (data.toLowerCase().contains(searchCont.text.toLowerCase())) {
            searchList.add(games[i]);
            setState(() {});
          }
        }
      }
    }).catchError((e) {
      log(e);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(language.lblSearchGame, showBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            autoFocus: true,
            textFieldType: TextFieldType.OTHER,
            decoration: inputDecoration(context, label: language.lblSearchGame, prefixIcon: Icon(Ionicons.search_outline)),
            controller: searchCont,
            onChanged: (v) async {
              setState(() {
                searchList = games.where((u) => (u.name!.toLowerCase().contains(v.toLowerCase()) || u.name!.toLowerCase().contains(v.toLowerCase()))).toList();
              });
            },
            onFieldSubmitted: (c) {
              loadGames();
              setState(() {});
            },
          ).paddingAll(16),
          searchList.isEmpty
              ? noDataWidget(context).center()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                      searchList.length,
                      (index) {
                        Category data = searchList[index];
                        return AnimationConfiguration.staggeredGrid(
                          duration: Duration(milliseconds: 750),
                          columnCount: 1,
                          position: index,
                          child: ItemWidget(data, isFavourite: true, onTap: () async {
                            if (Platform.isAndroid) {
                              if (data.url!.contains("market://") || data.url!.contains("play.google.com")) {
                                await launchUrl(Uri.parse(data.url!));
                              } else {
                                WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                              }
                            } else {
                              WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                            }
                          }),
                        );
                      },
                    ),
                  ),
                ).expand()
        ],
      ),
      bottomNavigationBar: mSearchBannerAds == '1' ? showBannerAds() : SizedBox(),
    );
  }
}
