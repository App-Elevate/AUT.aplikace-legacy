import 'package:autojidelna/classes_enums/all.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final typeId = 0; // Put an ID you didn't use yet.

  @override
  ThemeMode read(BinaryReader reader) => ThemeMode.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, ThemeMode obj) => writer.writeInt(obj.index);
}

class ThemeStyleAdapter extends TypeAdapter<ThemeStyle> {
  @override
  final typeId = 1; // Put an ID you didn't use yet.

  @override
  ThemeStyle read(BinaryReader reader) => ThemeStyle.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, ThemeStyle obj) => writer.writeInt(obj.index);
}

class TabletUiAdapter extends TypeAdapter<TabletUi> {
  @override
  final typeId = 2; // Put an ID you didn't use yet.

  @override
  TabletUi read(BinaryReader reader) => TabletUi.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, TabletUi obj) => writer.writeInt(obj.index);
}

class DateFormatOptionsAdapter extends TypeAdapter<DateFormatOptions> {
  @override
  final typeId = 3; // Put an ID you didn't use yet.

  @override
  DateFormatOptions read(BinaryReader reader) => DateFormatOptions.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, DateFormatOptions obj) => writer.writeInt(obj.index);
}
