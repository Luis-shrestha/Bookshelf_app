import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.dark) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeMode> emit) {
    emit(event.isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
