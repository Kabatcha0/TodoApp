import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/components/components/component.dart';
import 'package:todoapp/Shared/cubit/cubit/cubit.dart';
import 'package:todoapp/Shared/cubit/states/states.dart';

class Done extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
              List<Map> task = AppCubit.push(context).donetask;

          return builder(context, "Done task", task);
        });
  }
}
