package com.gladstargtschool6.investlearn

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.*

class AssessmentsActivity : AppCompatActivity() {
    private lateinit var adapter: AssessmentAdapter
    private var assessments: List<Assessment> = emptyList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_assessments)

        val rv = findViewById<RecyclerView>(R.id.assessmentsRecycler)
        val btnExport = findViewById<Button>(R.id.btnExportCsv)
        val emptyView = findViewById<TextView>(R.id.emptyText)

        rv.layoutManager = LinearLayoutManager(this)
        assessments = AssessmentStorage.load(this)

        if (assessments.isEmpty()) {
            emptyView.visibility = View.VISIBLE
        } else {
            emptyView.visibility = View.GONE
        }

        adapter = AssessmentAdapter(assessments)
        rv.adapter = adapter

        btnExport.setOnClickListener {
            if (assessments.isEmpty()) {
                android.widget.Toast.makeText(this, "No assessments to export", android.widget.Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            val csv = buildCsv(assessments)
            val send = Intent(Intent.ACTION_SEND).apply {
                type = "text/csv"
                putExtra(Intent.EXTRA_SUBJECT, "Assessments Export")
                putExtra(Intent.EXTRA_TEXT, csv)
            }
            startActivity(Intent.createChooser(send, "Share assessments as CSV"))
        }
    }

    private fun buildCsv(list: List<Assessment>): String {
        // CSV header
        val sb = StringBuilder()
        sb.append("timestamp,prompt,coaching,score\n")
        val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US)
        for (a in list) {
            val ts = sdf.format(Date(a.timestamp))
            sb.append(csvEscape(ts)).append(',')
            sb.append(csvEscape(a.prompt)).append(',')
            sb.append(csvEscape(a.coaching)).append(',')
            sb.append(a.score).append('\n')
        }
        return sb.toString()
    }

    private fun csvEscape(s: String): String {
        // Wrap in quotes and escape existing quotes
        val safe = s.replace("\"", "\"\"")
        return "\"" + safe + "\""
    }
}
