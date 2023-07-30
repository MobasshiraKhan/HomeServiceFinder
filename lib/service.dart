import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kormomukhi/servicedetails.dart';

class ServicePage extends StatefulWidget {
  final title;
  const ServicePage({Key? key, required this.title}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List searchservice = [];
  TextEditingController search = TextEditingController();
  List allservice = [
    {
      'title': 'Plumber',
      'subtitle': 'Plumber',
      'image': 'assets/svg/plumber-tap-svgrepo-com.svg',
      'details':
          'A plumber is a person whose job is to connect and repair things such as water and drainage pipes, baths, and toilets.',
    },
    {
      'title': 'Nurse',
      'subtitle': 'Nurse',
      'image': 'assets/svg/nurse-svgrepo-com.svg',
      'details':
          'Nursing encompasses autonomous and collaborative care of individuals of all ages, families, groups and communities, sick or well and in all settings. It includes the promotion of health, the prevention of illness, and the care of ill, disabled and dying people.'
    },
    {
      'title': 'Chef',
      'subtitle': 'Chef',
      'image': 'assets/svg/chef-svgrepo-com.svg',
      'details':
          'A chef is a professional cook and tradesman who is proficient in all aspects of food preparation, often focusing on a particular cuisine.'
    },
    {
      'title': 'Cleaner',
      'subtitle': 'Cleaner',
      'image': 'assets/svg/cleaner-man-svgrepo-com.svg',
      'details':
          'A person who cleans, especially one whose regular occupation is cleaning offices, buildings, equipment, etc. an apparatus or machine for cleaning, as a vacuum cleaner.'
    },
    {
      'title': 'Mechanic',
      'subtitle': 'Mechanic',
      'image': 'assets/svg/mechanic-svgrepo-com.svg',
      'details':
          'A mechanic is an artisan, skilled tradesperson, or technician who uses tools to build, maintain, or repair machinery, especially cars.'
    },
    {
      'title': 'Electrician',
      'subtitle': 'Electrician',
      'image': 'assets/svg/electricity-svgrepo-com.svg',
      'details':
          'An electrician is a tradesperson specializing in electrical wiring of buildings, transmission lines, stationary machines, and related equipment.'
    },
    {
      'title': 'Carpenter',
      'subtitle': 'Carpenter',
      'image': 'assets/svg/plumber-tap-svgrepo-com.svg',
      'details':
          'A carpenter is a person who makes things out of wood. You could hire a carpenter to build you a dining room table and two long benches. Carpenters specialize in woodworking, making furniture and buildings from wood and repairing various wooden things.'
    },
    {
      'title': 'Ac Mechanic',
      'subtitle': 'Ac Mechanic',
      'image': 'assets/svg/acmechanic.svg',
      'details':
          'An air conditioning (AC) technician is trained to install, maintain and repair air conditioning systems. They work in residential areas, commercial, industrial, school and hospital facilities with air conditioning units.'
    },
    {
      'title': 'Painter',
      'subtitle': 'Painter',
      'image': 'assets/svg/painter-svgrepo-com.svg',
      'details':
          'A house painter and decorator is a tradesman responsible for the painting and decorating of buildings, and is also known as a decorator or house painter.'
    },
    {
      'title': 'Tv Mechanic',
      'subtitle': 'Tv Mechanic',
      'image': 'assets/svg/tv-svgrepo-com.svg',
      'details':
          'Television Mechanic means an employee who is mainly employed to assemble and/or repair and/or service and/or test television receiving sets and/or parts.'
    },
    {
      'title': 'Event Planner',
      'subtitle': 'Event Planner',
      'image': 'assets/svg/Event-svgrepo-com.svg',
      'details':
          'An Event Planner is a professional who is in charge of logistics like choosing locations, hiring caterers, and coordinating with other vendors such as entertainment or other aspects to ensure a successful event.'
    },
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      searchservice = allservice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 0,
          titleSpacing: 0,
          title: TextField(
            controller: search,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search Service',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) {
              searchservice = [];
              for (int i = 0; i < allservice.length; i++) {
                if (allservice[i]['title']
                    .toLowerCase()
                    .contains(search.text.toLowerCase())) {
                  setState(() {
                    searchservice.add(allservice[i]);
                  });
                }
              }
            },
          )),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ListView.builder(
                itemCount: searchservice.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: SvgPicture.asset(searchservice[i]['image'],
                          width: 60),
                      title: Text(searchservice[i]['title']),
                      subtitle: Text(searchservice[i]['subtitle']),
                      trailing: GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Icon(Icons.arrow_right_alt_outlined,
                                color: Colors.white),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetails(
                                title: searchservice[i]['title'],
                                details: searchservice[i]['details'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
