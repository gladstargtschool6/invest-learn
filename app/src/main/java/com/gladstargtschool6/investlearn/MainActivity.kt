package com.gladstargtschool6.investlearn

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnEntrepreneur = findViewById<Button>(R.id.btnEntrepreneurship)
        val btnLeadership = findViewById<Button>(R.id.btnLeadership)
        val btnInteractive = findViewById<Button>(R.id.btnInteractive)
        val btnResources = findViewById<Button>(R.id.btnResources)

        btnEntrepreneur.setOnClickListener {
            startModule("Entrepreneurship")
        }

        btnLeadership.setOnClickListener {
            startModule("Leadership")
        }

        btnInteractive.setOnClickListener {
            startModule("Interactive Model")
        }

        btnResources.setOnClickListener {
            startActivity(Intent(this, FeedActivity::class.java))
        }
    }

    private fun startModule(name: String) {
        val intent = Intent(this, ModuleActivity::class.java)
        intent.putExtra("module_name", name)
        startActivity(intent)
    }
}
