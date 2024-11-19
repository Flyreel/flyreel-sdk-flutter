package com.lexisnexis.risk.flyreel_sdk_flutter

import android.app.Application
import android.content.Context
import android.net.Uri
import com.lexisnexis.risk.flyreel.Flyreel
import com.lexisnexis.risk.flyreel.FlyreelConfiguration
import com.lexisnexis.risk.flyreel.FlyreelEnvironment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlyreelSdkFlutterPlugin */
class FlyreelSdkFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var currentActivity: android.app.Activity? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                val arguments = call.arguments as Map<*, *>
                val organizationId = arguments["organizationId"] as String
                val settingsVersion = arguments["settingsVersion"] as Int
                val environment = arguments["environment"] as String

                Flyreel.initialize(
                    context as Application, FlyreelConfiguration(
                        organizationId = organizationId,
                        settingsVersion = settingsVersion,
                        environment = mapEnvironment(environment)
                    )
                )
                result.success(null)
            }

            "open" -> {
                val arguments = call.arguments as Map<*, *>
                val deeplinkUrl = arguments["deeplinkUrl"] as? String
                val shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as Boolean
                (currentActivity as? Context)?.let {
                    Flyreel.openFlyreel(
                        context = it,
                        deeplinkUri = deeplinkUrl?.let { url -> Uri.parse(url) },
                        shouldSkipLoginPage = shouldSkipLoginPage
                    )
                    result.success(null)
                } ?: result.notImplemented()
            }

            "openWithCredentials" -> {
                val arguments = call.arguments as Map<*, *>
                val zipCode = arguments["zipCode"] as String
                val accessCode = arguments["accessCode"] as String
                val shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as Boolean
                (currentActivity as? Context)?.let {
                    Flyreel.openFlyreel(
                        context = it,
                        zipCode = zipCode,
                        accessCode = accessCode,
                        shouldSkipLoginPage = shouldSkipLoginPage
                    )
                    result.success(null)
                } ?: result.notImplemented()
            }

            "checkStatus" -> {
                val arguments = call.arguments as Map<*, *>
                val zipCode = arguments["zipCode"] as String
                val accessCode = arguments["accessCode"] as String

                Flyreel.fetchFlyreelStatus(
                    zipCode = zipCode,
                    accessCode = accessCode,
                    onSuccess = { status ->
                        result.success(
                            mapOf(
                                "status" to status.status,
                                "expiration" to status.expiration
                            )
                        )
                    },
                    onError = { error ->
                        result.error(error.code.toString(), error.message, null)
                    }
                )
            }

            "enableLogs" -> {
                Flyreel.enableLogs()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun mapEnvironment(environment: String) =
        when (environment) {
            "production" -> FlyreelEnvironment.Production
            "sandbox" -> FlyreelEnvironment.Sandbox
            "staging" -> FlyreelEnvironment.Staging
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
