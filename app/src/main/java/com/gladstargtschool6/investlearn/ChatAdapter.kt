package com.gladstargtschool6.investlearn

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

sealed class ChatEntry(val text: String)
class UserEntry(text: String) : ChatEntry(text)
class AIEntry(text: String) : ChatEntry(text)

class ChatAdapter(private val items: MutableList<ChatEntry>) : RecyclerView.Adapter<ChatAdapter.VH>() {
    class VH(view: View) : RecyclerView.ViewHolder(view) {
        val text: TextView = view.findViewById(R.id.chatText)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_chat, parent, false)
        return VH(view)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        val item = items[position]
        holder.text.text = item.text
        // Simple styling: prefix
        holder.text.text = if (item is UserEntry) "You: ${item.text}" else "Coach: ${item.text}"
    }

    override fun getItemCount(): Int = items.size

    fun add(entry: ChatEntry) {
        items.add(entry)
        notifyItemInserted(items.size - 1)
    }
}
