package com.gladstargtschool6.investlearn

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.*

class AssessmentAdapter(private val items: List<Assessment>) : RecyclerView.Adapter<AssessmentAdapter.VH>() {

    class VH(view: View) : RecyclerView.ViewHolder(view) {
        val timestamp: TextView = view.findViewById(R.id.assessTimestamp)
        val prompt: TextView = view.findViewById(R.id.assessPrompt)
        val score: TextView = view.findViewById(R.id.assessScore)
        val coaching: TextView = view.findViewById(R.id.assessCoaching)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_assessment, parent, false)
        return VH(view)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        val a = items[position]
        val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US)
        holder.timestamp.text = sdf.format(Date(a.timestamp))
        holder.prompt.text = a.prompt
        holder.score.text = "Score: ${a.score}"
        holder.coaching.text = a.coaching
    }

    override fun getItemCount(): Int = items.size
}
