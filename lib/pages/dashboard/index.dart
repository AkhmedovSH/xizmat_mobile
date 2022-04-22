import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';
import '../../helpers/api.dart';

// import '../../components/drawer_app_bar.dart';

class Index extends StatefulWidget {
  final Function? openDrawerBar;
  const Index({Key? key, this.openDrawerBar}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _SearchDemoSearchDelegate delegate = _SearchDemoSearchDelegate();

  dynamic categories = [];
  dynamic user = {};

  dynamic teamService = [
    {
      'name': 'Лучшее',
      'select': false,
    },
    {
      'name': 'Персональные услуги',
      'select': false,
    },
    {
      'name': 'Персональные услуги',
      'select': false,
    },
  ];

  int? _lastIntegerSelected;
  final focusNode = FocusNode();

  getUser() async {
    final response = await get('/services/mobile/api/get-info');
    if (response != null) {
      setState(() {
        user = response;
      });
    }
  }

  getCategories() async {
    final response = await get('/services/mobile/api/category-list');
    if (response != null) {
      setState(() {
        categories = response;
      });
    }
  }

  getData() async {
    getUser();
    getCategories();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,

      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   // title: Text('data'),
      //   // centerTitle: true,
      //   leading: Container(),
      //   // leading: IconButton(
      //   //   onPressed: () {
      //   //     _scaffoldKey.currentState!.openDrawer();
      //   //   },
      //   //   icon: Icon(Icons.menu),
      //   // ),
      // ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   height: 240,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         'images/appBar.png',

            //         // width: double.infinity,
            //         // fit: BoxFit.fill,
            //         // height: 250,
            //       ),
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            //   child: Text('data'),
            // )
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'images/appBar.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: 250,
                ),
                Positioned(
                  bottom: 135,
                  left: 4,
                  child: IconButton(
                    onPressed: () {
                      widget.openDrawerBar!();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: white,
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.35,
                  bottom: 150,
                  child: SafeArea(
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  child: user['name'] != null
                      ? Text(
                          'Здравствуйте, ${user['name'] ?? ''}',
                          style: TextStyle(color: grey, fontWeight: FontWeight.w500),
                        )
                      : Text(''),
                ),
                Positioned(
                    bottom: 80,
                    child: Text(
                      'Какую услугу ищете?',
                      style: TextStyle(color: grey, fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: 330,
                      child: TextField(
                        onTap: () async {
                          focusNode.unfocus();
                          // Future.delayed(Duration(milliseconds: 500), () {

                          // });
                          final selected = await showSearch(
                            context: context,
                            delegate: delegate,
                          );
                          if (selected != null) {
                            if (selected != 0 && selected != _lastIntegerSelected) {
                              setState(() {
                                _lastIntegerSelected = selected;
                              });
                            }
                          }
                        },
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: lightGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.sort,
                            color: lightGrey,
                          ),
                          contentPadding: const EdgeInsets.all(18.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Color(0xFFECECEC), width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Color(0xFFECECEC), width: 0.0),
                          ),
                          filled: true,
                          fillColor: inputColor,
                          hintText: 'Специалист или услуга',
                          hintStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                        ),
                        style: TextStyle(color: lightGrey),
                      ),
                    ))
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            'Популярное',
                            style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/categories');
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Все категории',
                                  style: TextStyle(color: red, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: red,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 1; i < categories.length; i++)
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/categories-childs', arguments: categories[i]['id']);
                            },
                            child: Container(
                                width: 130,
                                height: 125,
                                margin: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F7FA),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Text(
                                        '${categories[i]['name']}',
                                        style: TextStyle(fontWeight: FontWeight.w700, color: black),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Image.asset(
                                        'images/c$i.png',
                                        height: 80,
                                        width: 100,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 10)),
                                  ],
                                )),
                          )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: Text(
                      'Командные услуги',
                      style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // for (var i = 0; i < teamService.length; i++)
                          Container(
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Лучшее',
                              style: TextStyle(color: white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: grey,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Персональные услуги ',
                              style: TextStyle(color: darkGrey, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: grey,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Персональные услуги ',
                              style: TextStyle(color: darkGrey, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridView.count(
                    childAspectRatio: 0.92,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.only(right: 16),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    children: [
                      for (int i = 0; i < 6; i++)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: inputColor,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      child: Image.asset('images/p$i.png', height: 105, width: double.infinity, fit: BoxFit.fill),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 23, bottom: 10, right: 11, left: 11),
                                      padding: const EdgeInsets.symmetric(horizontal: 11),
                                      child: const Text(
                                        'Полная уборка квартиры',
                                        style: TextStyle(
                                          fontFamily: 'ProDisplay',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        '123 44 +',
                                        style: TextStyle(
                                          color: Color(0xFF9C9C9C),
                                          fontFamily: 'ProDisplay',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: 80,
                                    left: MediaQuery.of(context).size.width * 0.18,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                                      child: const Icon(
                                        Icons.build,
                                        color: Color(0xFF9C9C9C),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchDemoSearchDelegate extends SearchDelegate {
  final List<int> _data = List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<int> suggestions = query.isEmpty ? _history : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map<String>((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int? searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return const Center(
        child: Text(
          'Не найдено',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: const [
        Text('data'),
        Text('data'),
        Text('data'),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String>? suggestions;
  final String? query;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions!.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions![i];
        return ListTile(
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query!.length),
              // style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                  text: '111',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected!(suggestion);
          },
        );
      },
    );
  }
}
