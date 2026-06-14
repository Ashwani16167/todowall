// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallpaperSettingsModelAdapter
    extends TypeAdapter<WallpaperSettingsModel> {
  @override
  final int typeId = 1;

  @override
  WallpaperSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperSettingsModel(
      templateIndex: fields[0] as int,
      fontSize: fields[1] as double,
      fontFamily: fields[2] as String,
      backgroundColorValue: fields[3] as int,
      textColorValue: fields[4] as int,
      backgroundImagePath: fields[5] as String?,
      taskSpacing: fields[6] as double,
      alignmentIndex: fields[7] as int,
      showCompletedTasks: fields[8] as bool,
      showDate: fields[9] as bool,
      showProgress: fields[10] as bool,
      maxTasksShown: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperSettingsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.templateIndex)
      ..writeByte(1)
      ..write(obj.fontSize)
      ..writeByte(2)
      ..write(obj.fontFamily)
      ..writeByte(3)
      ..write(obj.backgroundColorValue)
      ..writeByte(4)
      ..write(obj.textColorValue)
      ..writeByte(5)
      ..write(obj.backgroundImagePath)
      ..writeByte(6)
      ..write(obj.taskSpacing)
      ..writeByte(7)
      ..write(obj.alignmentIndex)
      ..writeByte(8)
      ..write(obj.showCompletedTasks)
      ..writeByte(9)
      ..write(obj.showDate)
      ..writeByte(10)
      ..write(obj.showProgress)
      ..writeByte(11)
      ..write(obj.maxTasksShown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
