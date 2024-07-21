import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/supports/applog/applog.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../../../theme/themeBloc/theme_bloc.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  State<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {

  late bool isDarkMode;
  late int selectedTheme;

  @override
  void initState() {
    super.initState();
    isDarkMode = context.read<ThemeBloc>().state == ThemeMode.dark;
    selectedTheme = !isDarkMode ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.kBackGroundColor,
      appBar: AppBar(
        title: Text("Theme Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: themeModeSetting(),
      ),
    );
  }
  Widget themeModeSetting() {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(spreadRadius: 1, color: Colors.black26, blurRadius: 2)
        ],
      ),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose Theme Mode",
              style: TextStyle(
                color: textColor!,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Light Theme'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: selectedTheme,
                      activeColor: Colors.red,
                      fillColor: WidgetStateProperty.all(constant.primaryColor),
                      splashRadius: 20,
                      onChanged: (int? value) {
                        setState(() {
                          selectedTheme = value!;
                          context.read<ThemeBloc>().add(
                            ThemeChanged(!isDarkMode),
                          );
                        });
                        AppLog.i("Theme View", "${!isDarkMode}");
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Dark Theme'),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: selectedTheme,
                      fillColor:  WidgetStateProperty.all(constant.primaryColor),
                      splashRadius: 25,
                      onChanged: (int? value) {
                        setState(() {
                          selectedTheme = value!;
                          context.read<ThemeBloc>().add(
                            ThemeChanged(!isDarkMode),
                          );

                        });
                        AppLog.i("Theme View", "${!isDarkMode}");
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
