package com.mighty.games

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;


import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

@Override
protected void onCreate(@Nullable Bundle savedInstanceState)
{ 
super.onCreate(savedInstanceState);
}
@Override
public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
super.configureFlutterEngine(flutterEngine);
FlutterYodo1Mas.getInstance().build(flutterEngine, this);
}

override fun onCreate(savedInstanceState: Bundle?) { 
super.onCreate(savedInstanceState)
}
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
super.configureFlutterEngine(flut terEngine)
FlutterYodo1Mas.getInstance()?.build(flutterEngine, this)
}

Yodo1MasAdBuildConfig config = new
Yodo1MasAdBuildConfig.Builder().enableUserPrivacyDialog(true).build();
Yodo1Mas.getInstance().setAdBuildConfig(config);

val config = Yodo1MasAdBuildConfig.Builder().enableUserPrivacyDialog(true).build()
Yodo1Mas.getInstance().setAdBuildConfig(config)
}
