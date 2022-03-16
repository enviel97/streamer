import 'package:flutter/material.dart';

class User {
  final int uid;
  final bool muted;
  final bool videoDisabled;
  final String? name;
  final Color? backgroundColor;

  const User({
    required this.uid,
    this.name,
    this.backgroundColor,
    this.muted = false,
    this.videoDisabled = false,
  });

  User copyWith({
    int? uid,
    bool? muted,
    bool? videoDisabled,
    String? name,
    Color? backgroundColor,
  }) {
    return User(
      uid: uid ?? this.uid,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
