package com.gladstargtschool6.investlearn

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import android.widget.Toast
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserException
import android.util.Xml
import java.io.IOException
import java.io.StringReader

data class FeedItem(
    val title: String,
    val link: String,
    val summary: String,
    val published: String
)

class FeedActivity : AppCompatActivity() {
    private val FEED_URL = "https://library.skillscommons.org/server/opensearch/search?format=atom&sort=score&sort_direction=DESC&query=Leadership%20and%20entrepreneurship%20&rpp=10"
    private val client = OkHttpClient()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_feed)

        val rv = findViewById<RecyclerView>(R.id.feedRecycler)
        rv.layoutManager = LinearLayoutManager(this)

        // Load feed in background
        lifecycleScope.launch {
            val result = fetchAndParseFeed()
            if (result == null) {
                Toast.makeText(this@FeedActivity, "Failed to load feed", Toast.LENGTH_LONG).show()
            } else {
                rv.adapter = FeedAdapter(result) { item ->
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(item.link))
                    startActivity(intent)
                }
            }
        }
    }

    private suspend fun fetchAndParseFeed(): List<FeedItem>? = withContext(Dispatchers.IO) {
        try {
            val request = Request.Builder().url(FEED_URL).build()
            client.newCall(request).execute().use { resp ->
                if (!resp.isSuccessful) return@withContext null
                val body = resp.body?.string() ?: return@withContext null
                return@withContext parseAtom(body)
            }
        } catch (e: IOException) {
            e.printStackTrace()
            return@withContext null
        }
    }

    private fun parseAtom(xml: String): List<FeedItem> {
        val items = mutableListOf<FeedItem>()
        val parser: XmlPullParser = Xml.newPullParser()
        parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false)
        parser.setInput(StringReader(xml))

        try {
            var eventType = parser.eventType
            var currentTitle = ""
            var currentLink = ""
            var currentSummary = ""
            var currentPublished = ""
            var insideEntry = false

            while (eventType != XmlPullParser.END_DOCUMENT) {
                val name = parser.name
                when (eventType) {
                    XmlPullParser.START_TAG -> {
                        if (name.equals("entry", ignoreCase = true)) {
                            insideEntry = true
                            currentTitle = ""
                            currentLink = ""
                            currentSummary = ""
                            currentPublished = ""
                        } else if (insideEntry && name.equals("title", ignoreCase = true)) {
                            currentTitle = parser.nextText()
                        } else if (insideEntry && name.equals("link", ignoreCase = true)) {
                            // link is an attribute href
                            val href = parser.getAttributeValue(null, "href")
                            if (!href.isNullOrEmpty()) currentLink = href
                        } else if (insideEntry && name.equals("summary", ignoreCase = true)) {
                            currentSummary = parser.nextText()
                        } else if (insideEntry && (name.equals("published", ignoreCase = true) || name.equals("updated", ignoreCase = true))) {
                            currentPublished = parser.nextText()
                        }
                    }
                    XmlPullParser.END_TAG -> {
                        if (name.equals("entry", ignoreCase = true)) {
                            items.add(FeedItem(currentTitle, currentLink, currentSummary, currentPublished))
                            insideEntry = false
                        }
                    }
                }
                eventType = parser.next()
            }
        } catch (e: XmlPullParserException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }

        return items
    }
}

class FeedAdapter(
    private val items: List<FeedItem>,
    private val onClick: (FeedItem) -> Unit
) : RecyclerView.Adapter<FeedAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val title: TextView = view.findViewById(R.id.feedTitle)
        val summary: TextView = view.findViewById(R.id.feedSummary)
        val published: TextView = view.findViewById(R.id.feedPublished)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_feed, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.title.text = item.title
        holder.summary.text = android.text.Html.fromHtml(item.summary, android.text.Html.FROM_HTML_MODE_LEGACY)
        holder.published.text = item.published
        holder.itemView.setOnClickListener { onClick(item) }
    }

    override fun getItemCount(): Int = items.size
}
