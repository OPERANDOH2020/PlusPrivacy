/*
 * Copyright (c) 2016 {UPRC}.
 *
 * OperandoApp is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OperandoApp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OperandoApp.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Contributors:
 *       Nikos Lykousas {UPRC}, Constantinos Patsakis {UPRC}
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

package eu.operando.proxy.filters.response;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.NavUtils;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.otto.Bus;
import com.squareup.otto.Subscribe;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;
import eu.operando.R;
import eu.operando.proxy.MainContext;
import eu.operando.proxy.database.DatabaseHelper;
import eu.operando.proxy.database.model.FilterFile;
import eu.operando.proxy.database.model.ResponseFilter;
import eu.operando.proxy.filters.DownloadTask;

public class ResponseFiltersActivity extends AppCompatActivity {

    private static final String TAG = "ResponseFiltersActivity";

    private MainContext mainContext = MainContext.INSTANCE;

    @InjectView(R.id.recycler_view_holder)
    public FrameLayout recyclerViewHolder;


    private RecyclerView recyclerView;

    private List<ResponseFilter> userFilters;

    private List<FilterFile> externalFilters;

    private UserResponseFiltersAdapter userResponseFiltersAdapter;

    private ExternalResponseFiltersAdapter externalResponseFiltersAdapter;

    private MenuItem deleteAction;

    private Bus BUS = mainContext.getBUS();

    private DatabaseHelper db = mainContext.getDatabaseHelper();

    private int viewSelected = 0; //0: user, 1: external

    private Set<ResponseFilter> userResponseFiltersSelected = new HashSet<>();
    private Set<FilterFile> externalFilterFilesSelected = new HashSet<>();

    protected void updateFiltersList() {
        userFilters = db.getAllUserResponseFilters();
        externalFilters = db.getAllResponseFilterFiles();
    }

    protected void inValidateSelections() {
        userResponseFiltersSelected.clear();
        externalFilterFilesSelected.clear();
        if (userResponseFiltersAdapter != null && externalResponseFiltersAdapter != null) {
            userResponseFiltersAdapter.updateEditAction();
            externalResponseFiltersAdapter.updateEditAction();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setTheme(MainContext.INSTANCE.getSettings().getThemeStyle().themeAppCompatStyle());
        updateFiltersList();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.filters_content);
        ButterKnife.inject(this);


        userResponseFiltersAdapter = new UserResponseFiltersAdapter();
        externalResponseFiltersAdapter = new ExternalResponseFiltersAdapter();

        recyclerView = new RecyclerView(this);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        //recyclerView.setAdapter(userResponseFiltersAdapter);
        //recyclerViewHolder.addView(recyclerView);


        //Setup Toolbar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setHomeButtonEnabled(true);
            actionBar.setDisplayHomeAsUpEnabled(true);
            View spinnerContainer = LayoutInflater.from(this).inflate(R.layout.toolbar_spinner,
                    toolbar, false);
            ActionBar.LayoutParams lp = new ActionBar.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            toolbar.addView(spinnerContainer, lp);

            ResponseFiltersSpinnerAdapter spinnerAdapter = new ResponseFiltersSpinnerAdapter();

            Spinner spinner = (Spinner) spinnerContainer.findViewById(R.id.toolbar_spinner);
            spinner.setAdapter(spinnerAdapter);
            spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    viewSelected = position;
                    recyclerViewHolder.removeAllViews();
                    //recyclerViewHolder.invalidate();
                    switch (position) {
                        case 0:
                            recyclerView.setAdapter(userResponseFiltersAdapter);
                            break;
                        case 1:
                            recyclerView.setAdapter(externalResponseFiltersAdapter);
                            break;
                        default:
                            recyclerView.setAdapter(userResponseFiltersAdapter);
                            break;
                    }
                    recyclerViewHolder.addView(recyclerView);
                    inValidateSelections();

                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {
                }
            });

        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.filter_menu, menu);
        deleteAction = menu.getItem(0);
        deleteAction.setEnabled(false);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    protected void onResume() {
        super.onResume();
        BUS.register(userResponseFiltersAdapter);
        BUS.register(externalResponseFiltersAdapter);
    }

    @Override
    protected void onPause() {
        super.onPause();
        BUS.unregister(userResponseFiltersAdapter);
        BUS.unregister(externalResponseFiltersAdapter);
    }

    @OnClick(R.id.add_filter)
    public void addFilter() {
        final EditText input = new EditText(this);
        input.setSingleLine(true);
        if (viewSelected == 0) { //User Filter
            input.setHint("Filtered String");
            AlertDialog.Builder builder = new AlertDialog.Builder(this).setTitle("New ResponseFilter")
                    .setView(input).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int whichButton) {

                            ResponseFilter responseFilter = new ResponseFilter();
                            responseFilter.setContent(input.getText().toString());
                            responseFilter.setSource(null);
                            db.createResponseFilter(responseFilter);
                            updateFiltersList();
                            userResponseFiltersAdapter.notifyItemInserted(userFilters.size() - 1);
                            recyclerView.scrollToPosition(userFilters.size() - 1);
                        }
                    }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int whichButton) {
                            // Canceled.
                        }
                    });

            final AlertDialog dialog = builder.create();

            input.addTextChangedListener(new TextWatcher() {
                @Override
                public void afterTextChanged(Editable s) {
                    if (s.length() >= 1) {
                        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(true);
                    } else dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);
                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                }
            });

            dialog.setOnShowListener(new DialogInterface.OnShowListener() {
                @Override
                public void onShow(DialogInterface dialog) {
                    ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);
                }
            });

            dialog.show();

        } else { //Imported filter list
            input.setHint("Enter URL");
            new AlertDialog.Builder(this).setTitle("Import filters from remote file")
                    .setView(input).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int whichButton) {

                    final String importUrl = input.getText().toString();
                    importExternalFilters(importUrl);

                }
            }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int whichButton) {
                    // Canceled.
                }
            }).show();
        }
    }


    protected void importExternalFilters(final String importUrl) {
        //String timestap = SimpleDateFormat.getDateTimeInstance().format(new Date().getTime());
        final File tmp = new File(getFilesDir(), "respfilters_" + System.currentTimeMillis());
        try {
            new DownloadTask(ResponseFiltersActivity.this, new URL(importUrl), tmp, new DownloadTask.Listener() {
                @Override
                public void onCompleted() {
                    Toast.makeText(ResponseFiltersActivity.this, R.string.msg_downloaded, Toast.LENGTH_LONG).show();


                    new AsyncTask<Void, Void, Integer>() {

                        ProgressDialog dialog;

                        @Override
                        protected void onPreExecute() {
                            dialog = ProgressDialog.show(ResponseFiltersActivity.this, null,
                                    "Parsing downloaded file...");
                            dialog.setCancelable(false);
                        }

                        @Override
                        protected Integer doInBackground(Void... params) {
                            int count = 0;
                            BufferedReader br = null;
                            try {
                                br = new BufferedReader(new FileReader(tmp));
                                String line;
                                while ((line = br.readLine()) != null) {
                                    int hash = line.indexOf('#');
                                    if (hash >= 0)
                                        line = line.substring(0, hash);
                                    line = line.trim();

                                    if (line.length() > 0) {
                                        ResponseFilter responseFilter = new ResponseFilter();
                                        responseFilter.setContent(line);
                                        responseFilter.setSource(importUrl);
                                        db.createResponseFilter(responseFilter);
                                        count++;
                                    }
                                }
                                Log.i(TAG, count + " entries read");
                            } catch (IOException ex) {
                                Log.e(TAG, ex.toString() + "\n" + Log.getStackTraceString(ex));
                            } finally {
                                if (br != null)
                                    try {
                                        br.close();
                                    } catch (IOException exex) {
                                        Log.e(TAG, exex.toString() + "\n" + Log.getStackTraceString(exex));
                                    }
                            }

                            return count;
                        }

                        @Override
                        protected void onPostExecute(Integer count) {
                            dialog.dismiss();
                            if (count > 0) {
                                updateFiltersList();
                                externalResponseFiltersAdapter.notifyDataSetChanged();
                            }
                        }
                    }.execute();


                    //recyclerView.scrollToPosition(userFilters.size() - 1);
                    //ServiceSinkhole.reload("hosts file download", ActivitySettings.this);
                }

                @Override
                public void onCancelled() {
                    if (tmp.exists())
                        tmp.delete();
                }

                @Override
                public void onException(Throwable ex) {
                    if (tmp.exists())
                        tmp.delete();

                    ex.printStackTrace();
                    Toast.makeText(ResponseFiltersActivity.this, ex.getMessage(), Toast.LENGTH_LONG).show();
                }
            }).execute();
        } catch (MalformedURLException ex) {
            ex.printStackTrace();
            Toast.makeText(ResponseFiltersActivity.this, ex.toString(), Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                NavUtils.navigateUpFromSameTask(this);
                break;
            case R.id.action_delete:
                if (viewSelected == 0)
                    userResponseFiltersAdapter.deleteCheckedItems();
                else
                    externalResponseFiltersAdapter.deleteCheckedItems();
                break;
            default:
                return super.onOptionsItemSelected(item);
        }
        return true;
    }


    private class ResponseFiltersSpinnerAdapter extends BaseAdapter {

        final String[] filterSrcArray = new String[]{"User specified", "External"};


        @Override
        public int getCount() {
            return filterSrcArray.length;
        }

        @Override
        public String getItem(int position) {
            return filterSrcArray[position];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View view = convertView != null ? convertView :
                    getLayoutInflater().inflate(R.layout.toolbar_spinner_item_actionbar, parent, false);

            TextView title = (TextView) view.findViewById(R.id.toolbarTitle);
            title.setText(getResources().getString(R.string.response_filters));

            TextView subtitle = (TextView) view.findViewById(R.id.toolbarSubtitle);
            subtitle.setText(getItem(position));
            return view;
        }

        @Override
        public View getDropDownView(int position, View convertView, ViewGroup parent) {

            View view = convertView != null ? convertView :
                    getLayoutInflater().inflate(R.layout.toolbar_spinner_item_dropdown, parent, false);

            TextView textView = (TextView) view.findViewById(R.id.toolbarSpinnerCell);
            textView.setText(getItem(position));

            return view;
        }
    }


    /*
    -----------------------------------------
    Response Filters entered manually by user
    -----------------------------------------
     */
    private class UserResponseFiltersAdapter extends RecyclerView.Adapter<UserResponseFiltersRowHolder> {

        @Override
        public UserResponseFiltersRowHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            return new UserResponseFiltersRowHolder(getLayoutInflater().inflate(R.layout.filter_row, parent, false));
        }

        @Override
        public void onBindViewHolder(UserResponseFiltersRowHolder holder, int position) {

            ResponseFilter responseFilter = userFilters.get(position);
            holder.setResponseFilter(responseFilter);
            holder.setChecked(userResponseFiltersSelected.contains(responseFilter));
        }

        @Override
        public int getItemCount() {
            return userFilters.size();
        }

        @Subscribe
        public void onUserResponseFilterCheckStateChangedEvent(UserResponseFilterCheckStateChangedEvent event) {
            if (event.isChecked) {
                userResponseFiltersSelected.add(event.responseFilter);
            } else {
                userResponseFiltersSelected.remove(event.responseFilter);
            }

            //Enable or disable the delete option when there are userResponseFiltersSelected items
            updateEditAction();
        }

        public void updateEditAction() {
            if (viewSelected == 0 && userResponseFiltersSelected.size() > 0)
                deleteAction.setEnabled(true);
            else deleteAction.setEnabled(false);
        }

        public void deleteCheckedItems() {
            for (ResponseFilter responseFilter : userResponseFiltersSelected) {
                db.deleteResponseFilter(responseFilter);
                updateFiltersList();
                userResponseFiltersAdapter.notifyDataSetChanged();
            }
            inValidateSelections();
        }
    }

    class UserResponseFiltersRowHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        private TextView contentLabel;
        private CheckBox checkBox;

        private ResponseFilter responseFilter;

        public UserResponseFiltersRowHolder(View itemView) {
            super(itemView);

            itemView.setOnClickListener(this);
            contentLabel = ButterKnife.findById(itemView, R.id.filter_content);
            checkBox = ButterKnife.findById(itemView, R.id.checkbox);
            checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    BUS.post(new UserResponseFilterCheckStateChangedEvent(responseFilter, isChecked));
                }
            });
        }

        public void setResponseFilter(ResponseFilter responseFilter) {
            this.responseFilter = responseFilter;
            contentLabel.setText(responseFilter.getContent());
        }

        public void setChecked(boolean checked) {
            checkBox.setChecked(checked);
        }

        @Override
        public void onClick(View view) {
            //https://stackoverflow.com/questions/14673716/android-how-to-set-the-edittext-cursor-to-the-end-of-its-text
            final EditText input = new EditText(itemView.getContext());
            input.setSingleLine(true);
            //input.setText("");
            input.append(responseFilter.getContent());
            AlertDialog.Builder builder = new AlertDialog.Builder(itemView.getContext()).setTitle("Edit ResponseFilter")
                    .setView(input).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int whichButton) {

                            responseFilter.setContent(input.getText().toString());
                            db.updateResponseFilter(responseFilter);
                            updateFiltersList();
                            userResponseFiltersAdapter.notifyDataSetChanged();

                        }
                    }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int whichButton) {
                            // Canceled.
                        }
                    });

            final AlertDialog dialog = builder.create();

            input.addTextChangedListener(new TextWatcher() {
                @Override
                public void afterTextChanged(Editable s) {
                    if (s.length() >= 1) {
                        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(true);
                    } else dialog.getButton(AlertDialog.BUTTON_POSITIVE).setEnabled(false);
                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                }
            });

            dialog.show();


        }
    }

    public class UserResponseFilterCheckStateChangedEvent {
        public boolean isChecked;
        public ResponseFilter responseFilter;

        public UserResponseFilterCheckStateChangedEvent(ResponseFilter responseFilter, boolean isChecked) {
            this.responseFilter = responseFilter;
            this.isChecked = isChecked;
        }
    }


    /*
    -------------------------------------------
    Response Filters imported from remote file
    -------------------------------------------
     */

    private class ExternalResponseFiltersAdapter extends RecyclerView.Adapter<ExternalResponseFiltersRowHolder> {

        @Override
        public ExternalResponseFiltersRowHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            return new ExternalResponseFiltersRowHolder(getLayoutInflater().inflate(R.layout.filter_row, parent, false));
        }

        @Override
        public void onBindViewHolder(ExternalResponseFiltersRowHolder holder, int position) {

            Log.e("TAG", externalFilters.toString());

            FilterFile filterFile = externalFilters.get(position);

            Log.e("TAG", "---->" + filterFile);

            holder.setFilterFile(filterFile);
            holder.setChecked(externalFilterFilesSelected.contains(filterFile));
        }

        @Override
        public int getItemCount() {
            return externalFilters.size();
        }

        @Subscribe
        public void onExternalResponseFilterCheckStateChangedEvent(ExternalResponseFilterCheckStateChangedEvent event) {
            if (event.isChecked) {
                externalFilterFilesSelected.add(event.filterFile);
            } else {
                externalFilterFilesSelected.remove(event.filterFile);
            }
            updateEditAction();
        }

        public void updateEditAction() {
            if (viewSelected == 1 && externalFilterFilesSelected.size() > 0)
                deleteAction.setEnabled(true);
            else deleteAction.setEnabled(false);
        }

        public void deleteCheckedItems() {
            for (FilterFile filterFile : externalFilterFilesSelected) {
                db.deleteResponseFilterFile(filterFile);
                updateFiltersList();
                externalResponseFiltersAdapter.notifyDataSetChanged();
            }
            inValidateSelections();
        }
    }

    class ExternalResponseFiltersRowHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        private TextView contentLabel;
        private CheckBox checkBox;

        private FilterFile filterFile;

        public ExternalResponseFiltersRowHolder(View itemView) {
            super(itemView);

            itemView.setOnClickListener(this);
            contentLabel = ButterKnife.findById(itemView, R.id.filter_content);
            checkBox = ButterKnife.findById(itemView, R.id.checkbox);
            checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    BUS.post(new ExternalResponseFilterCheckStateChangedEvent(filterFile, isChecked));
                }
            });
        }

        public void setFilterFile(FilterFile filterFile) {
            this.filterFile = filterFile;
            contentLabel.setText(filterFile.getTitle());
        }

        public void setChecked(boolean checked) {
            checkBox.setChecked(checked);
        }

        @Override
        public void onClick(View view) {
            final String importUrl = filterFile.getSource();

            new AlertDialog.Builder(itemView.getContext()).setTitle("FilterFile actions").setMessage("URL: " + importUrl)
                    .setPositiveButton("Update", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int whichButton) {

                            final String importUrl = filterFile.getSource();
                            db.deleteResponseFilterFile(importUrl);
                            importExternalFilters(importUrl);
                            updateFiltersList();
                            externalResponseFiltersAdapter.notifyDataSetChanged();
                            inValidateSelections();
                        }
                    }).setNeutralButton("Preview", new DialogInterface.OnClickListener() { //Scrollable dialog preview
                public void onClick(DialogInterface dialog, int whichButton) {

                    new AsyncTask<Void, Void, Spanned>() {
                        ProgressDialog dialog;

                        @Override
                        protected void onPreExecute() {
                            dialog = ProgressDialog.show(ResponseFiltersActivity.this, null,
                                    "Generating filters list...");
                            dialog.setCancelable(false);
                        }

                        @Override
                        protected Spanned doInBackground(Void... params) {
                            return Html.fromHtml(TextUtils.join("<br />", db.getAllResponseFiltersForSource(importUrl)));
                        }

                        @Override
                        protected void onPostExecute(Spanned filters) {
                            dialog.dismiss();
                            final AlertDialog.Builder prevDialog = new AlertDialog.Builder(itemView.getContext());
                            View rootView = getLayoutInflater().inflate(R.layout.dialog_scrollable_text, null);
                            prevDialog.setView(rootView);
                            final AlertDialog alertDialog = prevDialog.create();
                            ((TextView) rootView.findViewById(R.id.tv_scrollable_text)).setText(filters);
                            ((TextView) rootView.findViewById(R.id.tv_scrollable_text_dialog_title)).setText("Entries");
                            rootView.findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    alertDialog.dismiss();
                                }
                            });
                            alertDialog.show();
                        }
                    }.execute();

                }
            }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int whichButton) {
                    // Canceled.
                }
            }).show();
        }
    }


    public class ExternalResponseFilterCheckStateChangedEvent {
        public boolean isChecked;
        public FilterFile filterFile;

        public ExternalResponseFilterCheckStateChangedEvent(FilterFile filterFile, boolean isChecked) {
            this.filterFile = filterFile;
            this.isChecked = isChecked;
        }
    }
}
