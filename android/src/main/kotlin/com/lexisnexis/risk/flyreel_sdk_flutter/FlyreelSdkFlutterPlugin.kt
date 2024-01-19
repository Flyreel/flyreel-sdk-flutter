package com.lexisnexis.risk.flyreel_sdk_flutter

import android.app.Application
import android.content.Context
import com.lexisnexis.risk.flyreel.Flyreel
import com.lexisnexis.risk.flyreel.FlyreelConfig
import com.lexisnexis.risk.flyreel.FlyreelEnvironment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlyreelSdkFlutterPlugin */
class FlyreelSdkFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private var context: Context? = null
  private var currentActivity: android.app.Activity? = null

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "initialize" -> {
        val arguments = call.arguments as Map<*, *>
        val organizationId = arguments["organizationId"] as String
        val settingsVersion = arguments["settingsVersion"] as Int
        val environment = arguments["environment"] as String

        Flyreel.initialize(context as Application, FlyreelConfig(
          organizationId = organizationId,
          settingsVersion = settingsVersion,
          environment = mapEnvironment(environment)
        ))
        result.success(null)
      }
      "open" -> {
        (currentActivity as? Context)?.let {
          Flyreel.openFlyreel(it)
          result.success(null)
        } ?: result.notImplemented()
      }
      "enableDebugLogging" -> {
        Flyreel.enableDebugLogging()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun mapEnvironment(environment: String) =
    when(environment) {
      "production" -> FlyreelEnvironment.Production
      "sandbox" -> FlyreelEnvironment.Sandbox
      else -> throw Exception("Wrong Flyreel environment")
    }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flyreel_sdk_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }
  override fun onDetachedFromActivityForConfigChanges() {
    currentActivity = null
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }
  override fun onDetachedFromActivity() {
    currentActivity = null
  }
}
