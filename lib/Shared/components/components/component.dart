import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Shared/cubit/cubit/cubit.dart';

Widget defaultField(
    {double width = double.infinity,
    double height = 70,
    required String hintText,
    IconData? icon,
    required TextInputType type,
    required TextEditingController controller,
    Function()? onTap,
    bool read = false,
    required String? Function(String?) functionValidator}) {
  return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        readOnly: read,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onTap: onTap,
        keyboardType: type,
        controller: controller,
        validator: functionValidator,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white))),
      ));
}

Widget defaultTask(
    Map model, BuildContext context, String task, List<Map> tasks) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      AppCubit.push(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45,
            child: Text("${model['time']}"),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text("${model['date']}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.push(context)
                  .updateData(status: "done", id: model["id"]);
            },
            icon: const Icon(Icons.done),
            color: Colors.white,
            iconSize: 22,
          ),
          IconButton(
            onPressed: () {
              AppCubit.push(context)
                  .updateData(status: "archive", id: model["id"]);
            },
            icon: const Icon(Icons.archive),
            color: Colors.white,
            iconSize: 22,
          ),
        ],
      ),
    ),
  );
}

Widget builder(BuildContext context, String text, List<Map> task) {
  return ConditionalBuilder(
    condition: task.isNotEmpty,
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.list,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "$text is emty",
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          return defaultTask(task[index], context, "new task", task);
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.white,
            ),
          );
        },
        itemCount: task.length),
  );
}
