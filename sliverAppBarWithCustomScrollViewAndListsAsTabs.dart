


class SilverAppBarWithTabBarScreen extends StatefulWidget {
  @override
  _SilverAppBarWithTabBarState createState() => _SilverAppBarWithTabBarState();
}

class _SilverAppBarWithTabBarState extends State<SilverAppBarWithTabBarScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  //--------------------
  ScrollController _scrollViewController;
  SharedPreferences prefs;
  int refreshNum = 0;
  bool hasprefs = false;
  List listOfStories = [];
  double dragBehaviourValue = 0.0;
  String latestNetworkRequestCode;
  String popUpMenuText = 'Hide Seen';

  ///todo : provide actual california date;
  DateTime dateToday = DateTime.now();
  int selectedTab = 0;
  bool articleVisibility = true;
  String storiesVisibilityOption;

  Future fetchCurrentTime() async {
    await Future.delayed(Duration(minutes: 1));
    dateToday = DateTime.now();
    setState(() {});
  }

  getSharedPreferenceData() async {
    prefs = await SharedPreferences.getInstance();
    print('fetched pref');
    hasprefs = true;
    setState(() {});
  }


  fetchStoriesMapsList(
      int category, String categoryName, String fetchID) async {
    latestNetworkRequestCode = fetchID;
    print('day is $categoryName with $category days behind');
    try {
      List temp = await fetchNews('$category');
      if (latestNetworkRequestCode == fetchID) {
        listOfStories = temp;
      }
      print('list of stories length is ${listOfStories.length}');
    } catch (err) {
      setState(() {
        print('error in fetchNewsMap on newsListPage');
//        hasError = true;
      });
      throw err;
    }
    setState(() {});
  }
  //--------------------
  @override
  void initState() {
    getSharedPreferenceData();
    fetchStoriesMapsList(0, 'Latest', DateTime.now().toString());
    super.initState();
    fetchCurrentTime();
    _scrollViewController = ScrollController();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UtilityFunctions _utility = UtilityFunctions();

    List<String> kCategories = [
      'Latest',
      'Yesterday',
    ];

    kCategories.addAll(_utility.tabNameGenerator(dateToday));
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            title: Text("Silver AppBar With ToolBar"),
            pinned: true,
            expandedHeight: 160.0,
            bottom: new TabBar(
              tabs: [
                new Tab(text: 'Tab 1'),
                new Tab(text: 'Tab 2'),
                new Tab(text: 'Tab 3'),
              ],
              controller: controller,
            ),
          ),
          new SliverFillRemaining(
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                ListView.separated(
                  itemCount: 25,
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('item $index'),
                    );
                  },
                ),
                Text("Tab 2"),
                Text('Tab 3')
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
