// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/components/components/component.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todoapp/Shared/cubit/cubit/cubit.dart';
import 'package:todoapp/Shared/cubit/states/states.dart';

class BottomNavigation extends StatelessWidget {
  TextEditingController controlTitle = TextEditingController();
  TextEditingController controlTime = TextEditingController();
  TextEditingController controlDate = TextEditingController();
  TextEditingController controlStatus = TextEditingController();
  GlobalKey<ScaffoldState> keyScaffold = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..create(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppCubitInsert) {
            AppCubit.push(context).changeToggle(true);

            Navigator.pop(context);
          }
        },
        builder: (context, state) => Scaffold(
          key: keyScaffold,
          backgroundColor: const Color.fromARGB(255, 23, 17, 100),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(255, 23, 17, 100),
              title: Text(
                AppCubit.push(context).string[AppCubit.push(context).x],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          body: ConditionalBuilder(
            condition: state is! AppCubitRefresh,
            builder: (context) =>
                AppCubit.push(context).lists[AppCubit.push(context).x],
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              fixedColor: const Color.fromARGB(255, 23, 17, 100),
              unselectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              elevation: 5,
              backgroundColor: const Color.fromARGB(255, 61, 56, 121),
              currentIndex: AppCubit.push(context).x,
              onTap: (int index) {
                AppCubit.push(context).change(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived"),
              ]),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 61, 56, 121),
              child: AppCubit.push(context).toggle == false
                  ? const Icon(Icons.arrow_circle_down)
                  : const Icon(Icons.arrow_circle_up),
              onPressed: () {
                if (AppCubit.push(context).toggle == true) {
                  keyScaffold.currentState
                      ?.showBottomSheet((context) {
                        return Container(
                          color: const Color.fromARGB(255, 61, 56, 121),
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: keyForm,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultField(
                                    icon: Icons.title,
                                    type: TextInputType.text,
                                    hintText: "title",
                                    controller: controlTitle,
                                    functionValidator: (val) {
                                      if (val!.isEmpty) {
                                        return " title must be not empty";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultField(
                                    read: true,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        controlTime.text =
                                            value!.format(context).toString();
                                      }).catchError((Error) {
                                        print(Error.toString());
                                        Navigator.pop(context);
                                        AppCubit.push(context)
                                            .changeToggle(true);
                                      });
                                    },
                                    icon: Icons.timelapse,
                                    type: TextInputType.datetime,
                                    hintText: "time",
                                    controller: controlTime,
                                    functionValidator: (val) {
                                      if (val!.isEmpty) {
                                        return " time must be not empty";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultField(
                                    read: true,
                                    icon: Icons.date_range,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2025-03-05'))
                                          .then((value) {
                                        controlDate.text =
                                            DateFormat.yMMMd().format(value!);
                                      }).catchError((Error) {
                                        print(Error.toString());
                                        Navigator.pop(context);
                                        AppCubit.push(context)
                                            .changeToggle(true);
                                      });
                                    },
                                    hintText: "date",
                                    controller: controlDate,
                                    functionValidator: (val) {
                                      if (val!.isEmpty) {
                                        return " date must be not empty";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        AppCubit.push(context).changeToggle(true);
                      });
                  AppCubit.push(context).changeToggle(false);
                } else {
                  if (keyForm.currentState!.validate()) {
                    AppCubit.push(context).insert(
                        title: controlTitle.text,
                        time: controlTime.text,
                        date: controlDate.text);
                  }
                }
              }),
        ),
      ),
    );
  }
}
