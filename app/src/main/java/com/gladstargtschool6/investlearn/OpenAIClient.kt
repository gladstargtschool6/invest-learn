package com.gladstargtschool6.investlearn

import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

object OpenAIClient {
    private val client = OkHttpClient()
    private val gson = Gson()

    data class CoachResponse(val coaching: String, val score: Int)

    // Sends a Chat Completions style request to OpenAI (expects OPENAI_API_KEY in BuildConfig)
    fun coach(userText: String): CoachResponse? {
        val apiKey = BuildConfig.OPENAI_API_KEY
        if (apiKey == null || apiKey.isEmpty()) return fallback(userText)

        // Prompt instructing the model to return JSON with fields coaching and score (0-100)
        val systemPrompt = "You are an educational coach. Read the student's description of their challenge and provide: 1) actionable coaching steps they can take (short list), and 2) a numeric assessment score from 0 to 100 of preparedness/confidence. Return ONLY a JSON object with fields: coaching (string), score (integer)."
        val userPrompt = "Student: ${userText}\n\nRespond in JSON as described."

        val payload = mapOf(
            "model" to "gpt-3.5-turbo",
            "messages" to listOf(
                mapOf("role" to "system", "content" to systemPrompt),
                mapOf("role" to "user", "content" to userPrompt)
            ),
            "max_tokens" to 300
        )

        val bodyJson = gson.toJson(payload)
        val request = Request.Builder()
            .url("https://api.openai.com/v1/chat/completions")
            .addHeader("Authorization", "Bearer $apiKey")
            .addHeader("Content-Type", "application/json")
            .post(bodyJson.toRequestBody("application/json".toMediaType()))
            .build()

        client.newCall(request).execute().use { resp ->
            if (!resp.isSuccessful) return fallback(userText)
            val respBody = resp.body?.string() ?: return fallback(userText)

            // Parse response content -> choices[0].message.content
            try {
                val map: Map<String, Any> = gson.fromJson(respBody, Map::class.java)
                val choices = map["choices"] as? List<*>
                val first = choices?.getOrNull(0) as? Map<*, *>
                val message = first?.get("message") as? Map<*, *>
                val content = message?.get("content") as? String ?: return fallback(userText)

                // Try to parse content as JSON
                val parsed = try {
                    gson.fromJson(content, Map::class.java)
                } catch (e: Exception) {
                    null
                }

                if (parsed != null) {
                    val coaching = (parsed["coaching"] ?: parsed["advice"] ?: content).toString()
                    val scoreNum = (parsed["score"] ?: parsed["assessment"] ?: "0").toString()
                    val score = scoreNum.filter { it.isDigit() }.takeIf { it.isNotEmpty() }?.toInt() ?: 0
                    return CoachResponse(coaching, score)
                } else {
                    // If not JSON, return raw content and score 0
                    return CoachResponse(content.trim(), 0)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                return fallback(userText)
            }
        }
    }

    // Simple local fallback if no API key or call fails: rule-based advice and score
    private fun fallback(userText: String): CoachResponse {
        val coaching = StringBuilder()
        coaching.append("Quick coaching:\n")
        coaching.append("1) Define the problem and target customer.\n")
        coaching.append("2) Do a 1-week survey or talk to 10 potential customers.\n")
        coaching.append("3) Prototype a minimum viable version and test.\n")
        coaching.append("4) Measure, learn, iterate.\n")
        val score = when {
            userText.length > 200 -> 70
            userText.length > 80 -> 50
            else -> 30
        }
        return CoachResponse(coaching.toString(), score)
    }
}
