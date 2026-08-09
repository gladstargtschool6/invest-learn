package com.gladstargtschool6.investlearn

import android.content.Context
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AIActivity : AppCompatActivity() {
    private lateinit var adapter: ChatAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ai)

        val rv = findViewById<RecyclerView>(R.id.chatRecycler)
        val input = findViewById<EditText>(R.id.inputText)
        val send = findViewById<Button>(R.id.btnSend)

        adapter = ChatAdapter(mutableListOf())
        rv.adapter = adapter
        rv.layoutManager = LinearLayoutManager(this)

        send.setOnClickListener {
            val text = input.text.toString().trim()
            if (text.isEmpty()) {
                Toast.makeText(this, "Please enter a challenge or task", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            // Add user message to chat
            adapter.add(UserEntry(text))
            rv.scrollToPosition(adapter.itemCount - 1)
            input.text.clear()

            // Call AI in background
            lifecycleScope.launch {
                val response = withContext(Dispatchers.IO) {
                    OpenAIClient.coach(text)
                }

                if (response == null) {
                    Toast.makeText(this@AIActivity, "AI service unavailable. Try again later.", Toast.LENGTH_LONG).show()
                } else {
                    adapter.add(AIEntry(response.coaching))
                    rv.scrollToPosition(adapter.itemCount - 1)

                    // Save assessment locally
                    val assessment = Assessment(System.currentTimeMillis(), text, response.coaching, response.score)
                    AssessmentStorage.save(this@AIActivity, assessment)

                    Toast.makeText(this@AIActivity, "Assessment saved (score=${response.score})", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }
}
