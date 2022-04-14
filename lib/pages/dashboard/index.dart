import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../globals.dart' as globals;

import '../../components/drawer_app_bar.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _SearchDemoSearchDelegate delegate = _SearchDemoSearchDelegate();

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
      drawer: Container(
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width * 0.95,
        child: const DrawerAppBar(),
      ),
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
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: globals.white,
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
                  child: Text(
                    'Здравствуйте, Валентина',
                    style: TextStyle(color: globals.grey, fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                    bottom: 80,
                    child: Text(
                      'Какую услугу ищете?',
                      style: TextStyle(color: globals.grey, fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: 330,
                      child: TextField(
                        onTap: () async {
                          final int selected = await showSearch(
                            context: context,
                            delegate: delegate,
                          );
                          if (selected != _lastIntegerSelected) {
                            setState(() {
                              _lastIntegerSelected = selected;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: globals.lightGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.sort,
                            color: globals.lightGrey,
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
                          fillColor: globals.inputColor,
                          hintText: 'Специалист или услуга',
                          hintStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                        ),
                        style: TextStyle(color: globals.lightGrey),
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
                            style: TextStyle(color: globals.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(color: globals.red, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: globals.red,
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
                        for (var i = 1; i < 7; i++)
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/step-1');
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
                                        'Услуги \n курьеров ',
                                        style: TextStyle(fontWeight: FontWeight.w700, color: globals.black),
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
                      style: TextStyle(color: globals.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                              color: globals.red,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Лучшее',
                              style: TextStyle(color: globals.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: globals.grey,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Персональные услуги ',
                              style: TextStyle(color: globals.darkGrey, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: globals.grey,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                            child: Text(
                              'Персональные услуги ',
                              style: TextStyle(color: globals.darkGrey, fontWeight: FontWeight.w600),
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
                              color: globals.inputColor,
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
                                        color: globals.white,
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
