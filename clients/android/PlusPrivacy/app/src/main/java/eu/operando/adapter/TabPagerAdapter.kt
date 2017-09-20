package eu.operando.adapter

import android.content.Context
import android.os.Bundle
import android.support.design.widget.TabLayout
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentStatePagerAdapter
import android.support.v4.view.PagerAdapter
import eu.operando.fragment.TabFragment
import it.neokree.materialtabs.MaterialTab
import it.neokree.materialtabs.MaterialTabHost

/**
 * Created by Edy on 04-Apr-17.
 */
class TabPagerAdapter(fm: FragmentManager, val context: Context, val tabHost: TabLayout) : FragmentStatePagerAdapter(fm) {
    private val MAX_PAGE_LIMIT = 6
    private var fragments: ArrayList<TabFragment> = ArrayList()
    private var tabs: ArrayList<TabLayout.Tab> = ArrayList()
    private var urls: ArrayList<String> = ArrayList()


    override fun getItem(position: Int): Fragment {
        fragments[position].setUrlLoadListener { title, url ->
            tabs[position].text = title
            urls[position] = url
        }
        val b = Bundle()
        b.putString("url", urls[position])
        fragments[position].arguments = b
        return fragments[position]
    }

    override fun getCount(): Int {
        return fragments.size
    }

    override fun getItemPosition(`object`: Any?): Int {
        return PagerAdapter.POSITION_NONE
    }

    init {
        addTab("assets.www.google.ro")
    }

    fun addTab(url: String) {
        if (count > MAX_PAGE_LIMIT) {
            fragments.removeAt(0)
            tabs.removeAt(0)
            tabHost.removeTabAt(0)
            urls.removeAt(0)
        }
        fragments.add(TabFragment.newInstance(url))
        tabs.add(tabHost.newTab())
        tabHost.addTab(tabs[tabs.size - 1])
        urls.add(url)
        notifyDataSetChanged()


    }

    fun removeTab() {
        val position = tabHost.selectedTabPosition
        fragments.removeAt(position)
        notifyDataSetChanged()
        tabs.removeAt(position)
        tabHost.removeTabAt(position)
        urls.removeAt(position)
    }
}