package com.gladstargtschool6.investlearn

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity

class ModuleActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_module)

        val moduleName = intent.getStringExtra("module_name") ?: "Module"
        val titleView = findViewById<TextView>(R.id.moduleTitle)
        val startBtn = findViewById<Button>(R.id.btnStartExercise)
        titleView.text = moduleName

        startBtn.setOnClickListener {
            // Simple interactive quiz example
            showQuiz()
        }
    }

    private fun showQuiz() {
        val question = "You have an idea for a school store. What should you do first?"
        val options = arrayOf(
            "Build it immediately",
            "Research the market and talk to potential customers",
            "Ask a teacher to decide for you",
            "Wait until you have more time"
        )

        var selected = -1
        AlertDialog.Builder(this)
            .setTitle("Interactive Exercise")
            .setSingleChoiceItems(options, -1) { _, which -> selected = which }
            .setPositiveButton("Submit") { dialog, _ ->
                val result = when (selected) {
                    1 -> "Correct — start with research and validation."
                    0,2,3 -> "Good thought — but you should validate demand first."
                    else -> "Please select an option."
                }
                AlertDialog.Builder(this)
                    .setMessage(result)
                    .setPositiveButton("OK", null)
                    .show()
                dialog.dismiss()
            }
            .setNegativeButton("Cancel", null)
            .show()
    }
}
