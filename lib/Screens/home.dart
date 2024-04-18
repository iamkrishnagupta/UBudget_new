
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/utlity.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildBudgetSection(),
            Expanded(child: _buildTransactionHistory()),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 149, 136, 244),
            Color.fromARGB(255, 255, 255, 255),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Gupta Brothers',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBudgetInfo(
                      label: 'Total Budget',
                      value: total().toString(),
                      color: Colors.blue,
                    ),
                    _buildBudgetInfo(
                      label: 'Expenses',
                      value: expenses().toString(),
                      color: Colors.red,
                    ),
                    _buildBudgetInfo(
                      label: 'Revenue',
                      value: income().toString(),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetInfo({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 6),
        Text(
          '\$$value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions History',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                history = box.values.toList()[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    history.delete();
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset('images/${history.name}.png', height: 40),
                    ),
                    title: Text(
                      history.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${day[history.datetime.weekday - 1]}  ${history.datetime.year}-${history.datetime.day}-${history.datetime.month}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      history.amount,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: history.IN == 'Income' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


//Old code, 
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:managment/data/model/add_date.dart';
// import 'package:managment/data/utlity.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   var history;
//   final box = Hive.box<Add_data>('data');
//   final List<String> day = [
//     'Monday',
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     'friday',
//     'saturday',
//     'sunday'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: ValueListenableBuilder(
//               valueListenable: box.listenable(),
//               builder: (context, value, child) {
//                 return CustomScrollView(
//                   slivers: [
//                     SliverToBoxAdapter(
//                       child: SizedBox(height: 340, child: _head()),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Transactions History',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 19,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               'See all',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           history = box.values.toList()[index];
//                           return getList(history, index);
//                         },
//                         childCount: box.length,
//                       ),
//                     )
//                   ],
//                 );
//               })),
//     );
//   }

//   Widget getList(Add_data history, int index) {
//     return Dismissible(
//         key: UniqueKey(),
//         onDismissed: (direction) {
//           history.delete();
//         },
//         child: get(index, history));
//   }

//   ListTile get(int index, Add_data history) {
//     return ListTile(
//       leading: ClipRRect(
//         borderRadius: BorderRadius.circular(5),
//         child: Image.asset('images/${history.name}.png', height: 40),
//       ),
//       title: Text(
//         history.name,
//         style: TextStyle(
//           fontSize: 17,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       subtitle: Text(
//         '${day[history.datetime.weekday - 1]}  ${history.datetime.year}-${history.datetime.day}-${history.datetime.month}',
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       trailing: Text(
//         history.amount,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 19,
//           color: history.IN == 'Income' ? Colors.green : Colors.red,
//         ),
//       ),
//     );
//   }

//   Widget _head() {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 240,
//               decoration: BoxDecoration(
//                 color: Color(0xff368983),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Stack(
//                 children: [

//                   Padding(
//                     padding: const EdgeInsets.only(top: 35, left: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Text(
//                             'Welcome Back!',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20,
//                               color: Color.fromARGB(255, 224, 223, 223),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             'Gupta Brothers',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Positioned(
//           top: 140,
//           left: 37,
//           child: Container(
//             height: 170,
//             width: 320,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(47, 125, 121, 0.3),
//                   offset: Offset(0, 6),
//                   blurRadius: 12,
//                   spreadRadius: 6,
//                 ),
//               ],
//               color: Color.fromARGB(255, 47, 125, 121),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total Budget',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15),
//                   child: Row(
//                     children: [
//                       Text(
//                         '\$ ${total()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 13,
//                             backgroundColor: Color.fromARGB(255, 85, 145, 141),
//                             child: Icon(
//                               Icons.arrow_downward,
//                               color: Colors.white,
//                               size: 19,
//                             ),
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             'Revenue',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Color.fromARGB(255, 216, 216, 216),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 13,
//                             backgroundColor: Color.fromARGB(255, 85, 145, 141),
//                             child: Icon(
//                               Icons.arrow_upward,
//                               color: Colors.white,
//                               size: 19,
//                             ),
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             'Expenditure',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Color.fromARGB(255, 216, 216, 216),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '\$ ${income()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 17,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         '\$ ${expenses()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 17,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }


