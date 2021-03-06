import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcq_checker/src/blocs/student_bloc.dart';
import 'package:flutter_mcq_checker/src/models/module.dart';
import 'package:flutter_mcq_checker/src/models/student.dart';
import 'package:flutter_mcq_checker/src/widgets/data_unavailable.dart';
import 'package:flutter_mcq_checker/src/widgets/scan_answers.dart';
import 'package:flutter_mcq_checker/src/widgets/student_list_tile.dart';

class ResultScreen extends StatelessWidget {
  final Module module;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final StudentBloc bloc;

  ResultScreen({this.module, this.bloc});

  @override
  Widget build(BuildContext context) {
    //print(module.answers.first.toString());
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(module.module),
        actions: actions(),
      ),
      floatingActionButton: floatingActionButton(),
      body: buildBody(),
      // ListView.builder(
      //   itemCount: 10,
      //   padding: EdgeInsets.all(8.0),
      //   itemBuilder: (BuildContext context, int index) {
      //     if (index == 0) {
      //       return header();
      //     }
      //     return StudentListTile(index: index, scaffold: _scaffoldKey);
      //   },
      // ),
    );
  }

  List<Widget> actions() {
    return <Widget>[
      PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => onOptionItemSelect(value),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              value: 'scan',
              child: Text('Scan answers'),
            ),
            PopupMenuItem(
              value: 'add',
              child: Text('Add answers'),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit answers'),
            ),
          ];
        },
      ),
    ];
  }

  Widget buildBody() {
    return StreamBuilder(
      stream: bloc.students,
      builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
        if (!snapshot.hasData) {
          return DataUnavailable();
        }
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return header();
            }
            return StudentListTile(index: index, scaffold: _scaffoldKey);
          },
        );
      },
    );
  }

  Widget header() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 8.0),
          Text(
            'MCQ Result',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Group - ${module.group} / SEM ${module.sem} / ${module.year}',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w100,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Marked by : ${module.marker}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w100,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(
        CupertinoIcons.photo_camera,
        color: Colors.white,
        size: 35.0,
      ),
      tooltip: 'Add module',
      backgroundColor: Colors.green,
    );
  }

  void onOptionItemSelect(String value) async {
    switch (value) {
      case 'scan':
        showDialog(
          context: _scaffoldKey.currentContext,
          builder: (BuildContext context) {
            return ScanAnswers(scaffold: _scaffoldKey);
          },
        );
        break;
      case 'add':
        final result = await Navigator.pushNamed(
            _scaffoldKey.currentContext, 'addAnswers',
            arguments: module);
        print('Add page result is $result');

        break;
      case 'edit':
        final result = await Navigator.pushNamed(
            _scaffoldKey.currentContext, 'editAnswers',
            arguments: module);
        print('Edit page result is $result');
        break;
      default:
        break;
    }
  }

  void showSnackBar(int result) {
    if (result == 1) {
      Scaffold.of(_scaffoldKey.currentContext)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Answers updated successfully ..'),
        ));
    } else {
      Scaffold.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
        content: Text('Something went wrong..'),
      ));
    }
  }
}

// For github
// For github
// for github
