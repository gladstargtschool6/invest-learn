package com.gladstargtschool6.investlearn

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File

data class Assessment(
    val timestamp: Long,
    val prompt: String,
    val coaching: String,
    val score: Int
)

object AssessmentStorage {
    private const val FILE_NAME = "assessments.json"
    private val gson = Gson()

    fun save(context: android.content.Context, assessment: Assessment) {
        try {
            val file = File(context.filesDir, FILE_NAME)
            val list: MutableList<Assessment> = if (file.exists()) {
                val type = object : TypeToken<MutableList<Assessment>>() {}.type
                gson.fromJson(file.readText(), type)
            } else {
                mutableListOf()
            }
            list.add(0, assessment)
            file.writeText(gson.toJson(list))
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun load(context: android.content.Context): List<Assessment> {
        return try {
            val file = File(context.filesDir, FILE_NAME)
            if (!file.exists()) return emptyList()
            val type = object : TypeToken<List<Assessment>>() {}.type
            gson.fromJson(file.readText(), type)
        } catch (e: Exception) {
            e.printStackTrace()
            emptyList()
        }
    }
}
