package com.example.todo_wallpaper
import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class WallpaperManagerPlugin private constructor(private val context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        fun registerWith(flutterEngine: FlutterEngine, context: Context) {
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.todo_wallpaper/wallpaper")
            channel.setMethodCallHandler(WallpaperManagerPlugin(context))
        }
    }

    override fun onMethodCall(call: MethodChannel.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setHomeScreenWallpaper" -> setSingle(call, result, WallpaperManager.FLAG_SYSTEM)
            "setLockScreenWallpaper" -> setSingle(call, result, WallpaperManager.FLAG_LOCK)
            "setBothWallpapers" -> setBoth(call, result)
            "checkWallpaperPermission", "requestWallpaperPermission" -> result.success(true)
            else -> result.notImplemented()
        }
    }

    private fun setSingle(call: MethodChannel.MethodCall, result: MethodChannel.Result, flag: Int) {
        val path = call.argument<String>("path") ?: return result.error("INVALID_ARGUMENT", "Missing path", null)
        try {
            val bmp = BitmapFactory.decodeFile(File(path).absolutePath) ?: return result.error("DECODE_FAILED", "Cannot decode image", null)
            val wm = WallpaperManager.getInstance(context)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) wm.setBitmap(bmp, null, true, flag)
            else wm.setBitmap(bmp)
            result.success(true)
        } catch (e: Exception) { result.error("FAILED", e.message, null) }
    }

    private fun setBoth(call: MethodChannel.MethodCall, result: MethodChannel.Result) {
        val path = call.argument<String>("path") ?: return result.error("INVALID_ARGUMENT", "Missing path", null)
        try {
            val bmp = BitmapFactory.decodeFile(File(path).absolutePath) ?: return result.error("DECODE_FAILED", "Cannot decode image", null)
            val wm = WallpaperManager.getInstance(context)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wm.setBitmap(bmp, null, true, WallpaperManager.FLAG_SYSTEM)
                wm.setBitmap(bmp, null, true, WallpaperManager.FLAG_LOCK)
            } else wm.setBitmap(bmp)
            result.success(true)
        } catch (e: Exception) { result.error("FAILED", e.message, null) }
    }
}
