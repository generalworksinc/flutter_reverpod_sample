import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());

/// SharedPreferences で使用するテーマ保存用のキー
const _themePrefsKey = 'selectedThemeKey';

final themeSelectorProvider = StateNotifierProvider<ThemeSelector, ThemeMode>(
      (ref) => ThemeSelector(ref.read),
);

class ThemeSelector extends StateNotifier<ThemeMode> {
  final Reader _read;

  //選択したテーマを保存するためのローカル保存領域
  late final _prefs = _read(sharedPreferencesProvider);

  ThemeSelector(this._read) : super(ThemeMode.system) {
    // `SharedPreferences` を使用して、記憶しているテーマがあれば取得して反映する。
    final themeIndex = _prefs.getInt(_themePrefsKey);
    if (themeIndex == null) {
      return;
    }
    final themeMode = ThemeMode.values.firstWhere(
        (e) => e.index == themeIndex,
        orElse: () => ThemeMode.system,
    );
    state = themeMode;
  }

  //テーマの変更・保存を行う
  Future<void> changeAndSave(ThemeMode theme) async {
    _prefs.setInt(_themePrefsKey, theme.index); //SharedPreferenceに保存
    state = theme; //状態変更
  }

}