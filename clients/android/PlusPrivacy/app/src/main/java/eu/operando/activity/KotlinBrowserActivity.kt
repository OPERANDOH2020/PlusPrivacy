package eu.operando.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.design.widget.TabLayout
import android.support.v4.view.ViewPager
import android.support.v7.app.AlertDialog
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.*
import com.github.clans.fab.FloatingActionMenu
import eu.operando.R
import eu.operando.adapter.TabPagerAdapter

fun start(context: Context) {
    val starterIntent = Intent(context, KotlinBrowserActivity::class.java)
    context.startActivity(starterIntent)
}

class KotlinBrowserActivity : AppCompatActivity() {

    private lateinit var tabHost: TabLayout
    private lateinit var viewPager: ViewPager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_browser)
        initUI()

    }

    private fun initUI() {
        findViewById(R.id.back).setOnClickListener {
            finish()
        }
        tabHost = findViewById(R.id.tabhost) as TabLayout
        viewPager = findViewById(R.id.tab_view_pager) as ViewPager
        viewPager.adapter = TabPagerAdapter(supportFragmentManager,this,tabHost)
        viewPager.addOnPageChangeListener(TabLayout.TabLayoutOnPageChangeListener(tabHost))
        
        tabHost.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabReselected(tab: TabLayout.Tab?) {
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {
            }

            override fun onTabSelected(tab: TabLayout.Tab) {
                viewPager.currentItem = tab.position
            }

        })
        val fab_new_tab = findViewById(R.id.fab_new_tab)
        fab_new_tab.setOnClickListener({

            (viewPager.adapter as TabPagerAdapter).addTab("assets.www.google.ro")
            viewPager.setCurrentItem(viewPager.adapter.count - 1, true)
            (this@KotlinBrowserActivity.findViewById(R.id.fab_menu) as FloatingActionMenu).close(true)
//            val dialogLayout = LinearLayout(this@KotlinBrowserActivity)
//            val dialog = AlertDialog.Builder(this@KotlinBrowserActivity).create()
//            dialog.setView(dialogLayout)
//            val params = ViewGroup.LayoutParams(WRAP_CONTENT, WRAP_CONTENT)
//            dialogLayout.weightSum = 4f
//            dialogLayout.layoutParams = params
//            dialogLayout.apply {
//
//                val et = EditText(this@KotlinBrowserActivity).apply {
//                    hint = "URL"
//                    layoutParams = TableRow.LayoutParams(0, WRAP_CONTENT, 3f)
//                }
//                addView(et)
//                addView(Button(this@KotlinBrowserActivity).apply {
//                    setOnClickListener {
//                        (viewPager.adapter as TabPagerAdapter).addTab(et.text.toString())
//                        viewPager.setCurrentItem(viewPager.adapter.count - 1, true)
//                        dialog.dismiss()
//                        (this@KotlinBrowserActivity.findViewById(R.id.fab_menu) as FloatingActionMenu).close(true)
//                    }
//                    text = "OK"
//                    layoutParams = TableRow.LayoutParams(0, WRAP_CONTENT, 1f)
//                })
//
//            }
//            dialog.show()
        })
        findViewById(R.id.fab_close_tab).setOnClickListener {
            (viewPager.adapter as TabPagerAdapter).removeTab()
        }
        viewPager.offscreenPageLimit = 0
    }


}

