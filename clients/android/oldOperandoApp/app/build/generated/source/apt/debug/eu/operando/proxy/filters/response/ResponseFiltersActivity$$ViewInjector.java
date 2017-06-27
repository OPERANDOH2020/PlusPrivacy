// Generated code from Butter Knife. Do not modify!
package eu.operando.proxy.filters.response;

import android.view.View;
import butterknife.ButterKnife.Finder;

public class ResponseFiltersActivity$$ViewInjector {
  public static void inject(Finder finder, final eu.operando.proxy.filters.response.ResponseFiltersActivity target, Object source) {
    View view;
    view = finder.findRequiredView(source, 2131689654, "field 'recyclerViewHolder'");
    target.recyclerViewHolder = (android.widget.FrameLayout) view;
    view = finder.findRequiredView(source, 2131689655, "method 'addFilter'");
    view.setOnClickListener(
      new butterknife.internal.DebouncingOnClickListener() {
        @Override public void doClick(
          android.view.View p0
        ) {
          target.addFilter();
        }
      });
  }

  public static void reset(eu.operando.proxy.filters.response.ResponseFiltersActivity target) {
    target.recyclerViewHolder = null;
  }
}
