package com.example.allMusic;

import io.flutter.embedding.android.FlutterActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant.*;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "android/back/desktop";

    // @Override
    // void configureFlutterEngine(FlutterEngine flutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(this);
    //     new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
    //         new MethodChannel.MethodCallHandler() {
	// 			@Override
	// 			public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
	// 				if (methodCall.method.equals("backDesktop")) {
	// 					result.success(true);
	// 					moveTaskToBack(false);
	// 				} 
	// 			}
	// 		}
    //     );
    // }
}
