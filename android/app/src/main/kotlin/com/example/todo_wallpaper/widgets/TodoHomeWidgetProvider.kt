package com.example.todo_wallpaper.widgets
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.example.todo_wallpaper.R
import org.json.JSONArray

class TodoHomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val tasksJson = prefs.getString("flutter.widget_tasks", "[]") ?: "[]"
            val stats = prefs.getString("flutter.widget_stats", "") ?: ""
            val views = RemoteViews(context.packageName, R.layout.todo_home_widget)
            try {
                val arr = JSONArray(tasksJson)
                val sb = StringBuilder()
                for (i in 0 until minOf(arr.length(), 6)) {
                    val task = arr.getJSONObject(i)
                    sb.append("${if (task.optBoolean("completed")) "✓" else "•"} ${task.optString("title")}\n")
                }
                views.setTextViewText(R.id.widget_tasks, sb.toString().trimEnd())
                views.setTextViewText(R.id.widget_footer, stats)
            } catch (e: Exception) {
                views.setTextViewText(R.id.widget_tasks, "Open app to load tasks")
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
