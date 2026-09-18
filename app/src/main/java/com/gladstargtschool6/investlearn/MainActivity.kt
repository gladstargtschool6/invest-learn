package com.gladstargtschool6.investlearn

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.btnEntrepreneurship).setOnClickListener { startModule("Entrepreneurship") }
        findViewById<Button>(R.id.btnLeadership).setOnClickListener { startModule("Leadership") }
        findViewById<Button>(R.id.btnInteractive).setOnClickListener { startModule("Interactive Model") }
        findViewById<Button>(R.id.btnResources).setOnClickListener { startActivity(Intent(this, FeedActivity::class.java)) }
        findViewById<Button>(R.id.btnCoach).setOnClickListener { startActivity(Intent(this, AIActivity::class.java)) }
        findViewById<Button>(R.id.btnAssessments).setOnClickListener { openFlutterUi() }
    }

    private fun openFlutterUi() {
        try {
            val flutterActivity = Class.forName("io.flutter.embedding.android.FlutterActivity") as Class<out Activity>
            startActivity(Intent(this, flutterActivity))
        } catch (_: ClassNotFoundException) {
            Toast.makeText(this, "Flutter module is not generated; opening native assessments", Toast.LENGTH_LONG).show()
            startActivity(Intent(this, AssessmentsActivity::class.java))
        }
    }

    private fun startModule(name: String) {
        startActivity(Intent(this, ModuleActivity::class.java).putExtra("module_name", name))
    }
}
