var loadedData;
var dg_searched = false;
var paginationOriginalText;
var search_query;
var myNav = navigator.userAgent.indexOf('msie');
if (myNav > 0) {
  var str = 'You are using an incompatible browser. Please use latest version of Firefox or Chrome';
  showMsg(str, 'danger');
}
function showMsg(msg,type){
  return $.bootstrapGrowl(msg, { type: type });
}
function showColorbox(param) {
  var str;
  str = '<div class="colorbox_display">';
  if(param.title) {
    str += '<h4>'+param.title+'</h4><hr>';
  }
  if(msg) {
    str += param.str;
  }
  str+='</div>';
  $.colorbox({
    html: str,
    maxWidth: (param.maxWidth)?param.maxWidth:"500px",
    maxHeight: (param.maxHeight)?param.maxHeight:"400px",
  });
}

// Funciton that initializes datagrid that loads data via ajax
var showGrid = function(fl){

  // Validating search form data
  var inpObj = $('.niceform').serializeObject();

  if(fl=="search") {
    // Validate input form
    inpObj = validateForm(inpObj);
    if(!inpObj) {
      return false;
    }
    dg_searched = true;
    search_query = {search_input: JSON.stringify(inpObj)};
  }

  init = (fl=="search")? false : true; // If search clicked, then it is no more an initial load. So set it false
  // Main data grid initialization
  var dg = $('#dg').edatagrid({
    url: base_request_url + '/gps/json/search',
    columns: [dgcolumns],
    method: 'post',
    queryParams: (dg_searched)? search_query:'',
    iconCls: 'icon-search',
    singleSelect: false,
    remoteSort: true,
    fit: true,
    height: $(window).height()-85,
    //sortName: 'gsd_public_name',
    //sortOrder: 'desc',
    rowStyler: function(index,row){
      if (row.grs_gps_qc == "Fail" && row.grs_gps_qc != ""){
        return 'color:#cc0000;'; // return inline style
        // the function can return predefined css class and inline style
        // return {class:'r1', style:{'color:#fff'}};
      }
      else if (row.grs_gps_qc == "Pending" && row.grs_gps_qc != ""){
        return 'font-weight:bold;color:teal'; // return inline style
      }
      else if (row.grs_gps_qc == "Non Pneumo" && row.grs_gps_qc != ""){
        return 'color:#ccc'; // return inline style
      }
    },
    pagination: true,
    pageSize: (user_role == "admin")?15:15,
    pageList: [15, 25, 50, 100, 250, 500],
    toolbar: (user_role == "admin")?'#tb':'#general_tb',
    nowrap: false,
    rownumbers: (user_role == "admin")? false: false,
    onLoadError:function(err){
        showColorbox({
            str : 'Could not connect to server! Please login again.',
            title: 'TimeOut!'
        });
    },
    onLoadSuccess:function(data){
      if(data && data.err) {
        showMsg(data.err,'danger');
      }
      if(data && data.total == 0) {
        showMsg('No data available!')
        // showColorbox({
        //     str : 'No data was returned from the server',
        //     title: 'No data found!'
        // });
      }
      loadedData = $('#dg').datagrid('getData');
    },
    filterBtnIconCls:'icon-filter',
    onBeforeLoad:function(data){

      // Prevent datagrid reload if save pending
      var dg = $('#dg');
      var opts = dg.edatagrid('options');
      if (opts.editIndex >= 0){
        dg.edatagrid('endEdit',opts.editIndex);
      }
      checkIfDataEdited();
    },
    onBeforeEdit: function(index, rowData) {
      // Storing string data to check whether there are changes onAfterEdit

      // inititialize gps_qc and comments as they are not found in the rowData
      // So that it works while checking for any row edits in 'onAfterEdit'
      if(!rowData.grs_gps_qc) {
        rowData.grs_gps_qc = "";
      }
      if(!rowData.grs_comments) {
        rowData.grs_comments = "";
      }
      before_edit_rowData = JSON.stringify(rowData);
    },
    onAfterEdit: function(index, rowData) {
      // Check if any edit occured
      if (JSON.stringify(rowData) != before_edit_rowData) {
        var t = {};
        t['gss_sanger_id'] = rowData.gss_sanger_id;
        t['gss_lane_id'] = rowData.gss_lane_id;
        for (var i=0; i<editable_columns.length; i++) {
          t[editable_columns[i]] = rowData[editable_columns[i]];
        }
        chArr.push(t);
      }
      else {
        //console.log('No change');
      }
    },
    onError: function(index,row){
      showMsg('Error'+index,'danger');
    },
    onCheck: function(index, row) {
      var count = $(this).datagrid('getChecked').length;
      if (!paginationOriginalText) {
        paginationOriginalText = $('div.pagination div.pagination-info').html();
      }
      if(count > 0) {
        var str = (count > 1)?' rows' : ' row';
        var msgText = 'Selected ' + count + str;
        changePaginationText(msgText);
      }
      else {
        changePaginationText(paginationOriginalText);
      }
    },
    onUncheck: function(index, row) {
      var count = $(this).datagrid('getChecked').length;
      if(count > 0) {
        var str = (count > 1)?' rows' : ' row';
        var msgText = 'Selected ' + count + str;
        changePaginationText(msgText);
      }
      else {
        changePaginationText(paginationOriginalText);
      }
    },
    onCheckAll: function(rows) {
      // Check if Select All checkbox is clicked
      // If YES, then ask if user need to select the entire column or just the visible ones
      if(!paginationOriginalText) {
        paginationOriginalText = $('div.pagination div.pagination-info').html();
      }
      var str = '<h3>Would you like to select the entire resultset of ' + loadedData.total + ' rows?</h3>'
      $('#msg').html(str).dialog({
        width: 300,
        height: 150,
        closed: false,
        cache: false,
        modal: true,
        title: "Confirm",
        buttons: [{
          text: 'Yes',
          handler: function() {
            selectAllMeansSelectEntireData = true;
            var msgText = 'Selected ' + loadedData.total + ' rows';
            changePaginationText(msgText);
            $( '#msg' ).dialog( "close" );
          },
        },
        {
          text: 'No',
          handler: function() {
            selectAllMeansSelectEntireData = false;
            var msgText = 'Selected ' + rows.length + ' rows';
            changePaginationText(msgText);
            $( '#msg' ).dialog( "close" );
            return false;
        }
        }]
      });  //end confirm dialog
    },
    onUncheckAll: function(rows) {
      selectAllMeansSelectEntireData = false;
      changePaginationText(paginationOriginalText);
    }
  });
  return false;
};

// Validate form before search or Download
var validateForm = function(inpObj) {
    var reg1 = /=|>|</;
    var reg2 = /null/;
    // If combined search, then loop through each search string for validation
    for(var i=0; i<inpObj.length; i++) {
      // Trim search string
      if(inpObj[i][0]['search_str'] != "")
        inpObj[i][0]['search_str'] = $.trim(inpObj[i][0]['search_str'].replace(/,$/g, ""));

      // Check for missing search item if condition is not 'null/not null'
      if(!reg2.test(inpObj[i][0]["eq"]) && inpObj[i][0]['search_str'] == "") {
        str = "Input Missing!"
        // Show error
        showMsg(str, "danger");
        return false;
      }

      // Check for strings in search term if condition is "< / > / <= / >= / = / != ..."
      if(reg1.test(inpObj[i][0]["eq"]) && isNaN(inpObj[i][0]["search_str"])) {
        var str = 'Strings and multiple search items not allowed with "'+ inpObj[i][0]["eq"] + '" operator. Please use "IN / NOT IN';
        // Show error
        showMsg(str, "danger");

        return false;
      }
    }
    return inpObj;
}

// Check if datagrid has been edited and proceed accordingly.
var checkIfDataEdited = function() {
  var dg = $('#dg');
  var rows = dg.edatagrid('getChanges');
  if (rows.length){

    $('#msg').html('<h3>Datagrid edited, but not saved!</h3>').dialog({
      width: 300,
      height: 120,
      closed: false,
      cache: false,
      modal: true,
      title: "Confirm",
      buttons: [{
        text: 'Save',
        handler: function() {
          saveData();
          showMsg('Data saved successfully','success');
          $( '#msg' ).dialog( "close" );
        },
      },
        {
          text: 'Cancel',
          handler: function() {
            //dg.edatagrid('acceptChanges');
            $( '#msg' ).dialog( "close" );
            chArr = [];
            return false;
        }
      }]
    });  //end confirm dialog
  }
}

var chArr = new Array;
var before_edit_rowData, after_edit_rowData;
// Save to database
var saveData = function(){
  $('#dg').edatagrid('acceptChanges');
  if(chArr.length) {
    $.ajax({
      url: base_request_url + '/gps/update/comments',
      type: 'POST',
      data: {
        'data' : JSON.stringify(chArr),
      },
      dataType: 'JSON',
      beforeSend: block_screen('Saving changes...'),
      success: function(data, textStatus, jqXHR) {
        if(data && data.err) {
          var str = "Error: " + data.err + "<br>Message: " + data.errMsg
          showMsg(str,'danger');
        }
        else if(data.success) {
          showMsg(data.success + ((data.success > 1)?' rows':' row') + ' updated','success');
        }
      },
      error: function(xhr, status, error) {
        showMsg('Error: '+ error, 'danger');
        unblock_screen();
      },
      complete: function(){
        $('#dg').datagrid('reload');
        changePaginationText(paginationOriginalText);
        chArr = [];
        unblock_screen();
      }
    });
    chArr = [];
  }
}

/*
  Export data as CSV/XML based on row selected/ search / none=download all
*/
var init = true;
var exportData = function(extn) {
  // Get selected columns if any
  var chkdArr = $('#dg').datagrid('getChecked');
  var qdata = {};
  var url = '';

  if(selectAllMeansSelectEntireData) {
    chkdArr = [];
  }

  if (visible_columns.length <= 0) {
    showMsg('No visible columns to download.<br>Please use Show/Hide to view columns');
    return;
  }

  // Creating the query string to be passed via POST
  // If row selected
  if(chkdArr.length <= 0) {
    if(dg_searched) {
      var inpObj = $('.niceform').serializeObject();
      qdata = {'search_input': JSON.stringify(inpObj)};
    }
    else {
      qdata = {};
    }
    url = base_request_url + '/gps/json/download';
  }
  else {
    url = base_request_url + '/gps/json/download_selected';
    var arr = new Array();
    // Decision flag is used to check if the selected row has been excluded or not. Excluded data are not given for download
    // Currently allowing all download. So below statement is set to false
    var allGpsQCFail = false;
    jQuery.each(chkdArr, function(ind, row) {
      if(row.grs_gps_qc != "Fail"){
        allGpsQCFail = false;
      }
      var t = {};
      t['gss_sanger_id'] = row.gss_sanger_id;
      arr.push(t);
    });
    if(allGpsQCFail) {
      showMsg('Samples you have selected are categorized as not good and thus not available for download!');
      return;
    }

    if(arr.length <= 0) {
      showMsg('Please select your data to download!');
      return;
    }
    // Create query string
    qdata = {'download_selected': JSON.stringify(arr)};
  }

  // Pass Selected/Visible columns for download purpose
  qdata['selected_columns'] = visible_columns;

  $.ajax({
    url: url,
    type: 'POST',
    // If not initial loading, then donot pass form objects as user need to download all data
    data: qdata,
    dataType: 'JSON',
    beforeSend: block_screen('Downloading data... Please wait!'),
    success: function(data) {
      if(data.err) {
        showMsg('Error: '+ data.err, 'danger');
        return false;
      }
      (extn == "xml")?JSONtoXML(data):JSONtoCSV(data);
      fl = 'search';
      return false;
    },
    error: function(jqXHR, textStatus, errorThrown) {
      showMsg('Error: '+ errorThrown, 'danger');
      unblock_screen();
      return false;
    },
    complete: function() {
      unblock_screen();
    }
  });
  return false;
}


// XML headers used in creating XML file
var emitXmlHeader = function () {
    return '<?xml version="1.0"?>\n\
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"\n\
xmlns:o="urn:schemas-microsoft-com:office:office"\n\
xmlns:x="urn:schemas-microsoft-com:office:excel"\n\
xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"\n\
xmlns:html="http://www.w3.org/TR/REC-html40">\n\
<Worksheet ss:Name="GPS_statistics_and_metadata">\n\
<Table>\n';
}
var emitXmlFooter = function() {
    return '</Table>\n \
           </Worksheet>\n \
            </Workbook>\n';
};
var JSONtoXML = function (jsonObject) {
  var row;
  var col;
  var xml;
  var data = typeof jsonObject != "object"
           ? JSON.parse(jsonObject)
           : jsonObject;
  xml = emitXmlHeader();
  var type = 'String';
  for (i = 0; i < data.rows.length; i++) {
      xml += '  <Row>\n';
      for (col in data.rows[i]) {
          xml += '    <Cell><Data ss:Type="' + type  + '">' + escapeXml(data.rows[i][col]) + '</Data></Cell>\n';
      }
      xml += '  </Row>\n';
  }

  xml += emitXmlFooter();

  var contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  var blob = new Blob([xml], {
      'type': contentType
  });

  if ('download' in document.createElement("a")) {
    saveAs(blob, "gps_stat_metadata.xls");
  }
  else {
    var link = document.createElement("a");
    link.setAttribute('target', '_blank');
    link.setAttribute("href", window.URL.createObjectURL(blob));
    // link.setAttribute("download", "gps_stat_meta_data.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
  return false;
};

// For escaping characters for XML
var XML_CHAR_MAP = {
  '<': '&lt;',
  '>': '&gt;',
  '&': '&amp;',
  '"': '&quot;',
  "'": '&apos;'
};

function escapeXml (s) {
  if(s == null) {
    return "";
  }
  return s.replace(/[<>&"']/g, function (ch) {
    return XML_CHAR_MAP[ch];
  });
}

function JSONtoCSV(arrData) {
  var CSV = '';
  //1st loop is to extract each row
  for (var i = 0; i < arrData['rows'].length; i++) {
      var row = "";

      //2nd loop will extract each column and convert it in string comma-seprated
      for (var j=0; j<arrData['rows'][i].length; j++) {
          row += '"' + ((arrData['rows'][i][j])?arrData['rows'][i][j]:"") + '",';
      }
      row.slice(0, row.length - 1);
      //add a line break after each row
      CSV += row + '\r\n';
  }
  if (CSV == '') {
      alert("Invalid data");
      return;
  }
  //Generate a file name
  var filename = "gps_stat_metadata.csv";

  // Now the little tricky part.
  // you can use either>> window.open(uri);
  // but this will not work in some browsers
  // or you will not get the correct file extension
  //this trick will generate a temp <a /> tag
  var link = document.createElement("a");

  var blob = new Blob([CSV], {
     "type": "text/csv;charset=utf8;"
  });
  if ('download' in document.createElement("a")) {
    saveAs(blob, "gps_stat_metadata.csv");
  }
  else {
    var link = document.createElement("a");
    link.setAttribute('target', '_blank');
    link.setAttribute("href", window.URL.createObjectURL(blob));
    // link.setAttribute("download", "gps_stat_meta_data.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
  return false;
}

// Function to include all checked rows
var updateDecision = function(gpsQCVal) {
  $('#dg').edatagrid('acceptChanges');

  if (selectAllMeansSelectEntireData) {
    updateAllDecision(gpsQCVal);
  }
  else {
    var chkdArr = getChecked('#dg');
    var arr = new Array();
    if(chkdArr && chkdArr.length > 0) {
      jQuery.each(chkdArr, function(ind, row) {
        var t = {};
        t.gss_sanger_id = row.gss_sanger_id;
        t.gss_lane_id = row.gss_lane_id;
        t.gss_public_name = row.gss_public_name;
        arr.push(t);
      });
      sendForDecisionUpdate(arr, gpsQCVal);
    }
  }
};

var getChecked = function(gridEleId){
  var chkdArr = $(gridEleId).datagrid('getChecked');
  if(chkdArr.length <= 0) {
    showMsg('Please select a sample!');
    return false;
  }
  else {
    return chkdArr;
  }

}
var updateAllDecision = function(gpsQCVal) {
  // Get search input if search is active
  var search_input;
  if(search_query && search_query.search_input) {
    search_input = search_query.search_input;
  }

  $.ajax({
    url: base_request_url + '/get_column_data',
    type: 'POST',
    cache: false,
    data: {
      'select_columns' : ['gss_sanger_id','gss_lane_id','gss_public_name'],
      'search_input': (search_input)? search_input:''
    },
    dataType: 'JSON',
    success: function(data, textStatus, jqXHR) {
      if(data && data.err) {
        var str = "Error: " + data.err + "<br>Message:" + data.errMsg
        showMsg(str,'danger');
      }
      else {
        sendForDecisionUpdate(data.rows, gpsQCVal)
      }
    },
    error: function(jqXHR, textStatus, errorThrown) {
      showMsg('Error: '+ errorThrown, 'danger');
      unblock_screen();
    },
    complete: function(jqXHR, textStatus ){
      $('#dg').datagrid('reload');
      changePaginationText(paginationOriginalText);
      chArr = [];
      unblock_screen();
    }
  });
};

var sendForDecisionUpdate = function(dataArr, gpsQCVal) {
  if(dataArr.length > 0) {
    $.ajax({
      url: base_request_url + '/gps/update/decision',
      type: 'POST',
      cache:false,
      data: {
        'data' : JSON.stringify(dataArr),
        'type' : gpsQCVal
      },
      dataType: 'JSON',
      beforeSend: block_screen('Updating data'),
      success: function(data, textStatus, jqXHR) {
        if(data && data.err) {
          var str = "Error: " + data.err + "<br>Message:" + data.errMsg
          showMsg(str,'danger');
        }
        else if(data.success) {
          showMsg( data.success.rows + ((data.success.rows > 1)?' rows':' row') + ' updated as <em>' + data.success.final_sample_outcome + '</em>','success');
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        showMsg('Error: '+ errorThrown, 'danger');
        unblock_screen();
      },
      complete: function(jqXHR, textStatus ){
        $('#dg').datagrid('reload');
        changePaginationText(paginationOriginalText);
        chArr = [];
        unblock_screen();
      }
    });
    chArr = [];
  }
}

var populateSearchColumns = function() {
  var html_str = '';
  $.each(gpsdb_column_2d_array, function(k,v) {
    html_str += '<optgroup label="----------------------">';
    $.each(gpsdb_column_2d_array[k], function(index, value) {
      html_str += '<option value="'+ value +'">' + sliced_column(value) + '</option>';
    });
  })
  html_str += '</optgroup>';
  return html_str;
}

function sliced_column(column_name) {
  return column_name.slice(4).replace(/_/g,' ');
}

var gpsdb_column_2d_array = new Object();
var gpsdb_column_1d_array = new Array();
var dgcolumns = new Array();
var editable_columns = new Array();
editable_columns = ['grs_comments', 'grs_in_silico_st', 'grs_in_silico_serotype', 'grs_baps_1', 'grs_baps_2', 'grs_vaccine_status', 'grs_vaccine_period'];
var visible_columns = new Array();
visible_columns = ['gss_public_name', 'gss_lane_id', 'gsd_total_length', 'gss_total_yield', 'grs_gps_qc', 'grs_comments' ];
var exclude_columns = new Array();
exclude_columns = [];
var selectAllMeansSelectEntireData = false;
/*************   MAIN   **************/
$(document).ready(function(){

  //$('form').hide();
  // Clear the form input text boxes on load
  $('#search_str').val('');
  // Initialize a javascript variable with ArrayOfArrays representing columns in different tables that is passed to the template

  //Create a list of column names in a 1D array
  $.each(gpsdb_column_2d_array, function(i, row) {
    $.each(row, function(i, column_name) {
      gpsdb_column_1d_array.push(column_name);
    });
  });

  // Create a dropdown with the column names for search
  // Here the function populateSearchColumns() returns an HTML string with the <select> statement
  var html_str_search_dropdown = populateSearchColumns();

  // Appending the above created html string to the appropriate dropdown div
  // This capitalizes first letter of each column name using css
  jQuery('#column').append(html_str_search_dropdown).css('textTransform','capitalize');

  // This function creates a new row with form search fields and appends to the default search
  // when a user click on the + button to do a multiple condition search (AND search)
  $('.addfield').on('click',function(){
    var html_str = '\
          <dl>\
            <dt><p class="linkhead">AND <img class="closefieldm" onclick="$(this).parents(\'dl\').remove();" src="'+ base_request_url + '/static/images/cross.png"></p>\
              <dd>\
                <select size="1" style="width: 150px" name="columns" id="column">';
                html_str += html_str_search_dropdown;
                html_str += '</select>\
                <select size="1" style="width: 105px" name="eq" id="eq">\
                      <option value="in" selected="selected">IN</option>\
                      <option value="not in">NOT IN</option>\
                      <option value="like">LIKE</option>\
                      <option value="not like">NOT LIKE</option>\
                      <option value="REGEXP">REGEXP</option>\
                      <option value="is null">IS NULL</option>\
                      <option value="is not null">IS NOT NULL</option>\
                      <option value="=">=</option>\
                      <option value="!=">!=</option>\
                      <option value="<"><</option>\
                      <option value="<="><=</option>\
                      <option value=">">></option>\
                      <option value=">=">>=</option>\
                      <option value="showList">SHOW LIST</option>\
                </select><br>\
                <textarea name="search_str" id="search_str" rows="3" cols="35" placeholder="Paste your input here... Multiple entries should be separated by a newline character"></textarea>\
                <select size="1" style="width: 200px" name="search_populate" id="search_populate"></select>\
              </dd>\
            </dt>\
          </dl>';
    $('.niceform fieldset').append(html_str);
    $("select").css('textTransform','capitalize');
  });

  // Create columns for the datagrid
  var t = {};
  t['field'] = "ck";
  t['checkbox'] = true;
  t['hidden'] = (user_role == "admin")?false:false;
  dgcolumns.push(t);

  // Load columns to be visible in the same order as they are initialised in the visible_columns array.
  $.each(visible_columns, function(i, vcol_name) {
    if(exclude_columns.indexOf(vcol_name) == -1 && gpsdb_column_1d_array.indexOf(vcol_name) != -1) {
      var dg_column_field = createColumnFieldsForDatagrid(vcol_name)
      dgcolumns.push(dg_column_field);
    }
  });
  // Load rest of the columns other than in the visible_columns array
  $.each(gpsdb_column_1d_array, function(i,column_name) {
    if(exclude_columns.indexOf(column_name) == -1 && visible_columns.indexOf(column_name) == -1) {
      var dg_column_field = createColumnFieldsForDatagrid(column_name)
      dgcolumns.push(dg_column_field);
    }
  });

  // Load the datagrid with the default columns
  showGrid('init');
  // Load the dragging pane div with column name boxes for drag and drop
  load_div_dgcolumns();
});

function changePaginationText(text) {
  $('div.pagination div.pagination-info').html(text);
}

// Populate search on search type or search column change
$(document).on('change', "select[name='eq'], select[name='columns']", function () {
  var eq_ele;

  if($(this).attr('id') === "eq") {
    eq_ele = $(this);
    column_ele = $(this).prev('#column');
  }
  else {
    eq_ele = $(this).next("select[name='eq']");
    column_ele = $(this);
  }

  var selected_column = $(column_ele).val();

  if($(eq_ele).val() == 'showList') {
    var ele = this;
    // Fetch column data to populate in a drop down box.
    $.ajax({
      url: base_request_url + '/populate_search/' + selected_column,
      type: 'POST',
      cache: false,
      dataType: 'JSON',
      beforeSend: block_screen('Fetching data'),
      success: function(data, textStatus, jqXHR) {
        if(data && data.err) {
          var str = "Error: " + data.err + "<br>Message:" + data.errMsg
          showMsg(str,'danger');
        }
        else if(data[selected_column]) {
          var html_str = '';
          $.each(data[selected_column].sort(), function(index, value) {
            html_str += '<option value="'+ value +'">' + value + '</option>';
          });
          $(eq_ele).nextAll('#search_str').html('').hide();
          $(eq_ele).nextAll('#search_populate').html(html_str).show();
        }
        else {
          // Nothing to display
          var html_str = '<option value="">No Data Found</option>';
          $(eq_ele).nextAll('#search_str').html('').hide();
          $(eq_ele).nextAll('#search_populate').html(html_str).show();
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        showMsg('Error: '+ errorThrown, 'danger');
        $(eq_ele).nextAll('#search_populate').html('').hide();
        unblock_screen();
      },
      complete: function(jqXHR, textStatus ){
        unblock_screen();
      }
    });
  }
  else {
    $(eq_ele).nextAll('#search_str').html('').show();
    $(eq_ele).nextAll('#search_populate').html('').hide();
  }
});
// Create column fields with necessary attributes for the datagrid.
// This controls the edit permission for admin, show / hide of columns etc.
// Returns an object with its properties for a single column that is passed as argument
var createColumnFieldsForDatagrid = function(column_name)
{
  var t = {};
  t['field'] = column_name;
  t['title'] = sliced_column(column_name);
  t['width'] = 115;
  t['sortable'] = true;
  t['hidden'] = true;
  var reg = /comments|sample_outcome/
  if(reg.test(column_name)) {
    t['width'] = 200;
  }
  if(user_role == "admin" && editable_columns.indexOf(column_name) != -1) {
    t['editor'] = 'textarea';
    t['width'] = 200;
  }
  if(visible_columns.indexOf(column_name) != -1) {
    t['hidden'] = false;
  }
    return t;
};

// Create an object representation of the form fields and values
// Used while passing form parameters via datagrid
// {[ {column: 'gss_sanger_id'}, {eq: 'like'}, {} ], ...}
$.fn.serializeObject = function()
{
    var obj = [];
    var temp = {};
    var elem = document.getElementById('niceform_fieldset').elements;
    var field_count = 0;
    for(var i = 0; i < elem.length; i++) {
      if(elem[i].name === "columns" || elem[i].name === "eq" || elem[i].name === "search_populate") {
        temp[elem[i].name] = elem[i].value;
      }
      else if(elem[i].name == "search_str") {
        // Replace textarea string breaks with comma
        var str = elem[i].value.replace(/\n|\r|\n\r|\r\n/g,',');
        temp[elem[i].name] = str.replace(/^,+|,+$/, "");
        temp[elem[i].name] = str.replace(/,+/g, ",");
      }
      field_count++;
      if(elem[i].name === "search_populate") {
        obj.push([temp]);
        temp = {};
        field_count = 0;
      }
    }
    obj = resolveFormData(obj)
    return obj;
};

// Transform form data into the required format for POST
var resolveFormData = function(obj) {
  var newFormDataObj = [];
  for(var i=0; i<obj.length; i++) {
    t_obj = {};
    for(var k in obj[i]) {
      if(obj[i][0]['eq'] === "showList") {
        t_obj['columns'] = obj[i][0]['columns'];
        t_obj['eq'] = 'in';
        t_obj['search_str'] = obj[i][0]['search_populate'];
      }
      else {
        t_obj['columns'] = obj[i][0]['columns'];
        t_obj['eq'] = obj[i][0]['eq'];
        t_obj['search_str'] = obj[i][0]['search_str'];
      }

    }
    newFormDataObj.push([t_obj]);
  }
  return newFormDataObj;
}

$.xhrPool = []; // array of uncompleted requests
$.xhrPool.abortAll = function() { // our abort function
    $(this).each(function(idx, jqXHR) {
        jqXHR.abort();
    });
    $.xhrPool.length = 0
};

$.ajaxSetup({
    beforeSend: function(jqXHR) { // before jQuery send the request we will push it to our array
        $.xhrPool.push(jqXHR);
    },
    complete: function(jqXHR) { // when some of the requests completed it will splice from the array
        var index = $.xhrPool.indexOf(jqXHR);
        if (index > -1) {
            $.xhrPool.splice(index, 1);
        }
    }
});

$(window).bind('beforeunload',function(){
  // Prevent datagrid reload if save pending
  var dg = $('#dg');
  var opts = dg.edatagrid('options');
  if (opts.editIndex >= 0){
    dg.edatagrid('endEdit',opts.editIndex);
  }
  var rows = dg.edatagrid('getChanges');
  if (rows.length){
    return 'Data not saved!';
  }
});
var toggle = function(ele) {
  $(ele).next('form').slideToggle('slow');
}

$(document).ready(function(){
  var index;
  $('.draggable li.item').click(function () {
    // Based on class assignment, find out of it has
    if(!$(this).hasClass('add_border')) {
      $('#dg').datagrid('showColumn',this.id);
      $(this).addClass('add_border');
      // Making datagrid column field visible
      change_dgcolumns_hidden_property(this.id, true);
      visible_columns.push(this.id);
      console.log(this.id)
    }
    else {
      $('#dg').datagrid('hideColumn',this.id);
      $(this).removeClass('add_border');
      // Making datagrid column field hidden
      change_dgcolumns_hidden_property(this.id, false);
      index = visible_columns.indexOf(this.id);
      if (index > -1) {
        visible_columns.splice(index, 1);
      }
    }
    return false;
  });

  $('.showAll').click(function () {
    $.each(dgcolumns, function(ind, val) {
      if(val.field != 'ck') {
        var opt = $('#dg').datagrid('getColumnOption',val.field);
        if (opt.hidden) {
          visible_columns.push(val.field);
        }

        $('#dg').datagrid('showColumn',val.field);
        $('.draggable li.item').addClass('add_border');
        // Making datagrid column field visible
        change_dgcolumns_hidden_property(val.field, true);
      }
    });
  });
  $('.hideAll').click(function () {
    $.each(dgcolumns, function(ind, val) {
      if(val.field != 'ck') {
        $('#dg').datagrid('hideColumn',val.field);
        $('.draggable li.item').removeClass('add_border');
        // Making datagrid column field visible
        change_dgcolumns_hidden_property(val.field, false);
        index = visible_columns.indexOf(val.field);
        if (index > -1) {
          visible_columns.splice(index, 1);
        }
      }
    });
  });
});

var change_dgcolumns_hidden_property = function(id, visible_bool) {
  $.each(dgcolumns, function(ind, val) {
    if(val.field == id) {
      val.hidden = (visible_bool)?false:true;
    }
  })
}

function changeBackgroundSelected() {
  var col_arr = document.getElementsByClassName("item");
  var dg_col_opt;
  for(var i=0; i<col_arr.length; i++) {
    // Get column option from datagrid
    dg_col_opt = $('#dg').datagrid('getColumnOption', col_arr[i].id)
    if(dg_col_opt.field == col_arr[i].id && !dg_col_opt.hidden) {
      $('#'+col_arr[i].id).css('background','#eee').removeClass('remove_border').addClass('add_border');
    }
    else if(dg_col_opt.field == col_arr[i].id && dg_col_opt.hidden) {
      $('#'+col_arr[i].id).css('background','#eee').removeClass('add_border').addClass('remove_border');
    }
  }
}

function load_div_dgcolumns() {
  $('#drag').html('<ul></ul>');
  var li;

  //var cbox = $("<input>",{name: "add_col_cbox"})
  $.each(dgcolumns, function(i, val) {
    if(val.field != "ck") {
      // Inserting column names as list
      li = $("<li>", {id: val.field,  class: "item"});
      var str = '';
      str = val.title.replace(/<br>/g,' ');
      li.html(str);

      // Change color if column already displayed
      if(!val.hidden) {
        li.addClass('add_border');
      }

      // Inserting checkbox for multiple selection
      $('#drag ul').append(li);
    }
  });
}

$(document).ready(function(){
  var panel_open = {};
  panel_open['west'] = panel_open['east'] = false;
  panel_arr = ['west','east'];
  $.each(panel_arr, function(i, val){
    panel = $('#layout').layout('panel', val);    // get the west panel
    panel.panel({
        onExpand: function(){
            // $('#dg').datagrid('resize');
            panel_open[val] = true;
        },
        onResize: function(){
          $('#dg').datagrid('resize');
          // $('#layout').height(layout_height);
        },
        onCollapse:function(){
          $('#dg').datagrid('resize');
          // setLayoutTitle(val, arrExpand[i]);
          panel_open[val] = false;
        },
        onBeforeCollapse: function() {
          //alert($('a.panel-tool-collapse').data('clicked'));
        }
    });
  });
  // Set height of the layout to window height.
  setLayoutHeight();
  var layout_height = $('#layout').height();

  // Hiding layout panels
  $('.layout-expand-west .panel-body,.layout-expand-east .panel-body').css('display','none');
  $('.layout-expand-west a').attr('title','Click on the arrow to add or remove columns');
  $('.layout-expand-east a').attr('title','Click for Search options');

  // For view column button functionality
  // Only open. Closing via the arrow click
  $('#show_add_column_pane_button').on('click', function(){
    if(!panel_open['west']) {
      $('#layout').layout('expand','west');
      panel_open['west'] = true;
      $('#layout').height(layout_height-30);
    }
  });

  // For search link button functionality
  // Only open. Closing via the arrow click
  $('#show_search_pane_button').on('click', function(){
    if(!panel_open['east']) {
      $('#layout').layout('expand','east');
      panel_open['east'] = true;
      $('#layout').height(layout_height-30);
    }
  });

  // Resizing layout after panel resize click
  $('.layout-expand .panel-header a').on('click', function(){
    $('#layout').height(layout_height-30);
  });
});

// Set layout title rotated, when it is collapsed
function setLayoutTitle(region, expand_region) {
  var title = $('#layout').layout('panel', region).panel('options').title;  // get the west panel title
  var p = $('#layout').data('layout').panels[expand_region];  // the west expand panel
  p.html('<div style="-moz-transform: rotate(90deg);padding:6px 2px;-ms-transform: rotate(90deg);-webkit-transform: rotate(90deg)">'+title+'</div>');
}

// Set height of the layout to window height on page load.
// Layout cannot take height 100%. So need to tackle it this way.
function setLayoutHeight(){
    var c = $('#layout');
    c.height($(window).height()-61);
    c.layout('resize');
}

// Set height of the layout to window height on window resize.
$(window).bind('resize', function(){
  setLayoutHeight();
})

function showResistance() {
  checkIfDataEdited();
  $('#dg').edatagrid('acceptChanges');
  var chkdArr = $('#dg').datagrid('getChecked');
  var arr = new Array();
  jQuery.each(chkdArr, function(ind, row) {
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    var svgNS = svg.namespaceURI;
    var rect = document.createElementNS(svgNS,'rect');
    rect.setAttribute('x',ind * 1);
    rect.setAttribute('y',ind * 2);
    rect.setAttribute('width',10);
    rect.setAttribute('height',10);
    rect.setAttribute('fill','#95B3D7');
    svg.appendChild(rect);
    document.body.appendChild(svg);
  })
}

function downloadFastq() {
  // http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=ERS221588&result=read_run&fields=fastq_ftp
  $('#dg').edatagrid('acceptChanges');
  var chkdArr = getChecked('#dg');
  var arr = new Array();
  if(chkdArr) {
    if(chkdArr.length > 0) {
      $.each(chkdArr, function(ind, row) {
        arr.push(row.gsd_err);
      });
    }
  }
  else {
    return false;
  }
  var msg;
  console.log(arr)

  var url = base_request_url + '/fastq/url/';

  $.ajax({
    url: url,
    data: {
      'accession' : arr,
      'type' : 'fastq_ftp'
    },
    type: 'POST',
    dataType: 'json',
    beforeSend: block_screen('Downloading Fastq'),
    success: function(data, textStatus, jqXHR) {
      if(Object.keys(data).length) {
        var html = createFastqHTMLStr(data)
        $.colorbox({
          html: html,
          width: '600',
          maxHeight: $('#layout').height() * 0.8,
          maxWidth: $('#layout').width() * 0.8
        });
      }
      else {
        showMsg('Fastq not available!')
      }
    },
    error: function(jqXHR, textStatus, errorThrown) {
      showMsg('Error: '+ errorThrown, 'danger');
      $('.fastqlink').unbind('click', false);
      unblock_screen();
    },
    complete: function(jqXHR, textStatus ){
      $('.fastqlink').unbind('click', false);
      chArr = [];
      unblock_screen();
    }
   });
}
function createFastqHTMLStr(urlMap) {
  var html = '<div class="colorbox_display">';
  var url_download_str = '';
  for (var err in urlMap) {
    html += '<h4>' + err + '</h4>';
    $.each(urlMap[err], function(i, url) {
      html += '<a target="_blank" href="'+url+ '">' + url +'</a><br>';
      url_download_str += url + '\n';
    });
  }
  html += '</div>';
  var data = "text/json;charset=utf-8," + encodeURIComponent(url_download_str);
  html =  '<div class="colorbox_head">'+
          '  <a class="button bgblue" href="data:' + data + '" download="fastq_urls.txt">Click to download as text </a> ' +
          '  <span class="smalltext"> Use unix command <code>wget -i fastq_urls.txt </code>to download via ftp</span>'+
          // '  <a href="javascript:void(0);" class="easyui-linkbutton" onClick="showColorbox({str: $(\'#fastq_help\').html()})" iconCls="icon-help" title="Fastq help"> ? </a> '+
          '</div><div id="fastq_cbox_help"></div>' + html

  return html;
}

function showUpdateSTWindow() {
  // $('.update_st_form_container').slideDown();
  $('.update_st_form_container').show().window({
      width:'auto',
      height:'auto',
      title: 'Bulk Upload',
      collapsible: false,
      minimizable: false,
      maximizable: false,
      modal:true
  });
}

$("select[name='st_update_type']").change( function() {
  var selectVal = $("select[name='st_update_type']").val();

  if(selectVal == '') {
    $('.st_upload_tip').html('');
  }
  var str = 'Input file must contain 2 columns <br> <span class="red">Lane ID</span> (Text) and <span class="red">'
            + sliced_column(selectVal)
            + '</span>';

  if (selectVal === "mlst") {
    str = 'Input file must contain the <br> <span class="red">Lane ID</span> column followed by <span class="red"> mlst profile columns </span>'+
          'in the following order <br> <div class="bulk-upload-column-display blue"> aroe gdh gki recp spi xpt ddl </div>';
  }
  if (selectVal === "antibiotic") {
    str = 'Input file must contain the <br> <span class="red">Lane ID</span> column followed by <span class="red"> antibiotic profile columns </span>'+
          'in the following order <div class="bulk-upload-column-display blue"> lane  VanS_F_1_AF155139 aac3_IIa_X13543 aacA_AB304512 aac_3_IVa_1_X01385  aac_6prime_Ii_1_L12710  aac_6prime_aph_2primeprime__1_M13771  aadA2 aadB_1_JN119852 aadD_1_AF181950 ant_6_Ia_1_AF330699 aph_3prime_III_1_M26832 arsB_M86824 blaTEM1_1_JF910132  blaTEM33_1_GU371926 blaZ_34_AP003139  blaZ_35_AJ302698  blaZ_36_AJ400722  blaZ_39_BX571856  cadA_BX571856 cadD_BX571858 catQ_1_M55620 cat_5_U35036  cat_pC194_1_NC_002013 cat_pC221_1_X02529  cat_pC233_1_AY355285  cmx_1_U85507  dfrA12_1_AB571791 dfrA14_1_DQ388123 dfrC_1_GU565967 dfrC_1_Z48233 dfrG_1_AB205645 ermA_2_AF002716 ermB_10_U86375  ermB_16_X82819  ermB_18_X66468  ermB_20_AF109075  ermB_6_AF242872 ermC_13_M13761  fexA_1_AJ549214 fosA_8_ACHE01000077 fosB_1_X54227 fusA_17_DQ866810  fusB_1_AM292600 fusD_AP008934 ileS2_GU237136  lnuA_1_M14039 lsaC_1_HM990671 mecA_10_AB512767  mecA_15_AB505628  mefA_10_AF376746  mefA_3_AF227521 mefE_AE007317 merA_L29436 merB_L29436 merR_L29436 mphA_1_D16251 mphB_1_D85892 mphC_2_AF167161 msrA_1_X52085 msrC_2_AF313494 msrD_2_AF274302 msrD_3_AF227520 qacA_AP0003367  qepA_1_AB263754 smr_qacC_M37889 strA_1_M96392 strA_4_NC_003384  strB_1_M96392 str_1_X92946  str_2_FN435330  sul1_1_AY224185 sul1_9_AY963803 sul2_9_FJ197818 tet32_2_EF626943  tet38_3_FR821779  tetB_4_AF326777 tetG_4_AF133140 tetK_4_U38428 tetL_2_M29725 tetL_6_X08034 tetM_10_EU182585  tetM_12_FR671418  tetM_13_AM990992  tetM_1_X92947 tetM_2_X90939 tetM_4_X75073 tetM_5_U58985 tetM_6_M21136 tetM_8_X04388 tetO_1_M18896 tetO_3_Y07780 tetR_sgi1 tetS_3_X92946 vgaA_1_M90056 </div>';
  }
  $('.st_upload_tip').html(str);
});

function st_update_validator() {
  if($('#st_update_file').val() == "") {
    showMsg('Please select your file to upload!');
    return false;
  }
  var reg = /\.xlsx$|\.xls$|\.csv$/;
  if(!reg.test($('#st_update_file').val())) {
    showMsg('Invalid file. Only .xls, .xlsx and .csv files are valid!');
    return false;
  }

  if($("select[name='st_update_type']").val() === undefined || $("select[name='st_update_type']").val() === "") {
    showMsg('Please select the type of data you are uploading!');
    return false;
  }
  return true;
}

// ST bulk update function
(function() {

  $('.update_st_form').ajaxForm({
    resetForm: true,
    beforeSubmit: function(){
      if (st_update_validator()) {
        block_screen('Processing data');
      }
      else {
        return false;
      }
    },
    success: function(res) {
      var res = JSON.parse(res);
      if(res && res.err) {
        var str = "Error: " + res.err;
        str += (res.errMsg)?"<br>Message: " + res.errMsg : "";
        showMsg(str,'danger');
      }
      else if(res.rows_updated) {
        showMsg(res.rows_updated + ((res.rows_updated > 1)?' rows':' row') + ' updated','success');
      }

      if(res.rows_not_updated && res.rows_not_updated.length > 0) {
        var str = '<div class="colorbox_display"><h4>' + res.rows_updated + ((res.rows_updated > 1)?' rows':' row') + ' updated! </h4><hr><div class="err">Lane IDs not updated are shown below:</div>';
        $.each(res.rows_not_updated, function(i,lane){
          str += lane + ' ';
        });
        str += '</div>'

        $.colorbox({
          html: str,
          maxHeight: $('#layout').height() * 0.7,
          width: $('#layout').width() * 0.7
        })
     }
    },
    complete: function(xhr) {
      $('#dg').datagrid('reload');
      changePaginationText(paginationOriginalText);
      // $('.update_st_form_container').window('close');
      $('.st_upload_tip').html('');
      unblock_screen();
    },
    error: function(jqXHR, textStatus, errorThrown) {
      showMsg(errorThrown, 'danger');
    }
  });

})();
window.onload = function() {
  setTimeout(unblock_screen(),100);
}

function downloadZipFiles(type) {
  checkIfDataEdited();
  $('#dg').edatagrid('acceptChanges');
  var chkdArr = getChecked('#dg');
  var arr = new Array();
  if(chkdArr) {
    if(chkdArr.length > 0) {
      $.each(chkdArr, function(ind, row) {
        // Push only if lane id is present
        if(row.gss_lane_id != "" && row.gss_lane_id != undefined && row.grs_gps_qc != 0 )
          arr.push(row.gss_lane_id);
      });
      if(arr.length <= 0) {
        // Lane id not found
        showMsg('Download not available for the selected samples!');
        return false;
      }
    }
    else {
      // Lane id not found
      showMsg('Please select a sample!');
      return false;
    }
  }
  else {
    return false;
  }
  var msg;
  var str = '';
  var url = base_request_url + '/download/' + type;
  $.ajax({
    url: url,
    data: {
      'lane_ids' : arr,
    },
    type: 'POST',
    // processData: false,
    dataType: 'json',
    success: function(data, textStatus, jqXHR) {
      // var xhrtype = jqXHR.getResponseHeader('Content-Type');
      // console.log(type);

      // var blob = new Blob([response], { type: xhrtype });
      // var filename = type+".zip";
      // if (typeof window.navigator.msSaveBlob !== 'undefined') {
      //     // IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created. These URLs will no longer resolve as the data backing the URL has been freed."
      //     window.navigator.msSaveBlob(blob, filename);
      // } else {
      //     var URL = window.URL || window.webkitURL;
      //     var downloadUrl = URL.createObjectURL(blob);

      //     if (filename) {
      //         // use HTML5 a[download] attribute to specify filename
      //         var a = document.createElement("a");
      //         // safari doesn't support this yet
      //         if (typeof a.download === 'undefined') {
      //             window.location = downloadUrl;
      //         } else {
      //             a.href = downloadUrl;
      //             a.download = filename;
      //             document.body.appendChild(a);
      //             a.click();
      //         }
      //     } else {
      //         window.location = downloadUrl;
      //     }

      //     setTimeout(function () { URL.revokeObjectURL(downloadUrl); }, 100); // cleanup
      // }
      // console.log(data);
      if(data['file']) {
        var html = createDownloadLink(data['file'], type);
        // openDialog(html, 'Assembly Download', 600, 400);
      }
      else if(data['err']) {
        showMsg(data['err']||'Error occured!', 'danger')
      }
    },
    beforeSend: function(){
      if(arr.length >= 100) {
        block_screen('More number of '+type+' to download. Please wait!');
      }
      else {
        block_screen('Downloading ' + type);
      }
    },
    error: function(jqXHR, textStatus, errorThrown) {
      showMsg('Error: '+ errorThrown, 'danger');
      $('.fastqlink').unbind('click', false);
      unblock_screen();
    },
    complete: function(jqXHR, textStatus ){
      $('.fastqlink').unbind('click', false);
      chArr = [];
      unblock_screen();
    }
   });
}

// Download popup
function createDownloadLink(file, type) {
      var url = file;
      var downloadLink = document.createElement("a");
      downloadLink.href = url;
      if('download' in document.createElement('a')) {
        downloadLink.download = type + ".zip";
      }
      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
}

var showHelp = function(){
  $('#help_select_column').html($('#column').html());
  $('#help_eq').html($('#eq').html());
  $.colorbox({
    html:  $(".help_container").html(),
    maxHeight: $('#layout').height() * 0.8, // 80% of the layout height and width
    maxWidth: $('#layout').width() * 0.8,
    // close: '<img src="'+base_request_url+'static/images/close.png">'
  });
}

var showColHeaderHelp = function(type) {
  $.colorbox({
    href: base_request_url + type,
    maxHeight: "80%",
    maxWidth: "80%",
    close: 'Close this window'
  });
}

var showHelpVideo = function(type) {
  var html = '<div class="videoWrapper">\
<iframe width="'+ ($('#layout').width()) +'" height="'+ ($('#layout').height()-35) +'" src="//www.youtube.com/embed/zT0mPo3nOBQ?autoplay=1&vq=hd720" frameborder="0" allowfullscreen></iframe>\
</div>';

  $.colorbox({
    html: html,
    maxHeight: "95%",
    maxWidth: "100%",
    opacity: 0.00001,
    transition: 'elastic',
    top: "31px"
  });

}

/************************   GC IMAGES Section    ********************************/
var gc_img_data = {};
var show_GC_images = function() {
  var chkdArr = getChecked('#dg');
  var arr = new Array();
  if(chkdArr) {
    if(chkdArr.length > 0) {
      $.each(chkdArr, function(ind, row) {
        // Push only if lane id is present
        if(row.gss_lane_id && row.gss_lane_id != "") {
          arr.push(row.gss_lane_id);
        }
      });
      if(arr.length <=0) {
        // No selection made
        showMsg('Please select a sample with a lane id!');
        return false;
      }
    }
    else {
      // No selection made
      showMsg('Please select a sample with a lane id!');
      return false;
    }
  }
  else {
    return false;
  }
  var msg;
  var str = '';
  var url = base_request_url + '/get_gc_images/';
  $.ajax({
    url: url,
    data: {
      'lane_ids' : arr,
    },
    type: 'POST',
    dataType: 'json',
    beforeSend: function(){
      if(arr.length >= 100) {
        block_screen('Processing request...')
      }
      else {
        block_screen('Retrieving GC data');
      }
    },
    success: function(data, textStatus, jqXHR) {
      if(Object.keys(data).length <= 0) {
        showMsg('Sorry, GC content data not available for the selected samples.');
        unblock_screen();
        return;
      }
      gc_img_data = data;
      var html = '<div class="colorbox_head center head">GC Content [ % ] <a class="linkhead bgblue right" onClick=\'downloadAllGCImages();\'>Download All </a></div>';
      html += '<div id="container">';
      html += '<div id="gc_img_container"><img id="gc_img" src="data:image/png;base64,'+ data[Object.keys(data)[0]] +'"></div>'
      html += '<div class="colorbox_display">';
      html += '<div id="thumbscontainer"><div id="hovered_lane" style="position:absolute;"></div>';
      for(var lane in data) {
        html += "<img id='thumb_img' class='img_tooltip' onClick='$(\"#gc_img\").attr(\"src\", this.src);' title='"+ lane +"' src='data:image/png;base64," + data[lane] + "'>";
      }
      html += '</div></div></div>'
      var default_lane = Object.keys(data)[0];
      // showGCImage(default_lane, data[default_lane]);
      var wd = ($('#layout').width() < 600)? $('#layout').width() * 0.8 : '600';
      $.colorbox({
        html:  html,
        width: wd,
        maxHeight: $('#layout').height() * 0.95, // 80% of the layout height and width
        maxWidth: "600px",
        // close: '<img src="'+base_request_url+'static/images/close.png">'
      });
      // $('#gc_img_container').width($())

      xOffset = 10;
      yOffset = 30;
        // these 2 variable determine popup's distance from the cursor
        // you might want to adjust to get the right result
      /* END CONFIG */
      $("img.img_tooltip").hover(function(e){
        this.t = this.title;
        this.title = "";
        $("body").append("<p id='tooltip'>"+ this.t +"</p>");
        $("#tooltip")
          .css("top",(e.pageY + yOffset) + "px")
          .css("left",(e.pageX + xOffset) + "px")
          .css("z-index", 99999)
          .fadeIn("fast");
          },
            function(){
              this.title = this.t;
              $("#tooltip").remove();
            });
        $("img.img_tooltip").mousemove(function(e){
        $("#tooltip")
          .css("top",(e.pageY + yOffset) + "px")
          .css("left",(e.pageX - $('#tooltip').width()/2) + "px");
      });
      unblock_screen();
    },
    error: function() {
      unblock_screen();
      showMsg('Could not complete your request. Please try again later.')
    },
    complete: function() {
      unblock_screen();
    }
  });
}

var downloadAllGCImages = function(){
  var zip = new JSZip();
  var filename, img_data;
  for(var lane in gc_img_data) {
    filename = lane + '.png';
    img_data = gc_img_data[lane];
    zip.file(filename, img_data, {base64: true});
  }
  var content = zip.generate({type:"blob"});
  // see FileSaver.js
  saveAs(content, "GPS_dataviewer_GC_images.zip");
}

/**************************   BLOCK SCREEN FOR PROCESSING   ******************************/

function block_screen(text) {
  // document.getElementById('block_screen').style.display = 'block';
  $('#block_screen').show().css('background', 'rgba(51,51,51,0.9');
  if(text) changeLoadingText(text);
}

function unblock_screen() {
  $('#block_screen').hide();
}

function changeLoadingText(text) {
  $('#block_screen p').html(text)
}

/************************   CHART SECTION    ********************************/

function displayChartWindow() {
  var html = '';
  var div_max_height = $('#layout').height() * 0.95;
  var key = 'Chart_Window';

  if(opened_window[key] != undefined) {
    var open_ele = opened_window[key]['div'];
    $.colorbox({
      html: open_ele,
      width: $('#layout').width(),
      height: div_max_height
    })
    $('#chartDiv').show();
    return;
  }
  $('#chartDisplayContainer').css('height', div_max_height);
  var ele = $('#chartDiv');
  $.colorbox({
    html: ele,
    width: $('#layout').width() * 1,
    height: div_max_height, // 80% of the layout height and width
    // close: '<img src="'+base_request_url+'static/images/close.png">'
    onClosed: function(){
      createWindow('Chart_Window',ele);
    }
  });

  $('#chartDiv').show();
}

// Create a window list to store all opened model windows. So that you can get back to it when you need.
var opened_window = {};

function createWindow(key, element) {
  if(opened_window[key] == undefined)
    addToWindowMenu(key);
  var hash = {};
  hash['div'] = element;

  opened_window[key] = hash;
  // Add/ append only if it is a new window
}

function addToWindowMenu(key){
  if($('#window').length <= 0) {
    // Create window menu
    var anchor = document.createElement('a');
    anchor.id="window";
    anchor.innerHTML = 'Window';
    $('#tb').append(anchor)
  }
  var div = document.createElement('div');
  div.setAttribute('plain', true);
  $(div).on('click', function(){
    var open_ele = opened_window[key]['div'];
    $.colorbox({
      html: open_ele,
      width: $('#layout').width(),
      height: $('#layout').height()
    })
  });
  div.innerHTML = key;
  $('#opened_window').append(div).show();

  $('#window').menubutton({
    iconCls: 'icon-eye',
    menu: '#opened_window'
  });
}

$(document).ready(function(){
  $(document).on('click','#chartSelect li', {} ,function(e){
    var column = this.id
    // New chart id for the dynamic div
    var chart_id = 'chart_'+ column;

    var ele = this;
    if(!$(this).hasClass('add_border')) {
      $(this).addClass('add_border');
    }
    else {
      // Remove the chart
      $('#'+chart_id).parent().remove();
      $(this).removeClass('add_border');
      return;
    }

    // Get the data count for the column given
    $.ajax({
      url: base_request_url + '/count/meta/' + column,
      type: 'GET',
      dataType: 'json',
      beforeSend: block_screen('Fetching data...'),
      success: function(data, textStatus, jqXHR) {
        if(Object.keys(data).length) {
          var chart_div = document.createElement('div');
          chart_div.id = 'chartDisplayDiv';
          $('#chartDisplayContainer').append(chart_div);

          var chart = document.createElement('div');
          chart.id = chart_id;
          chart.style.width = '300px';
          chart.style.height = '300px';

          if(column == 'gmd_gender') {
            // chart.style.position = 'relative';
            chart.style.float = 'left';
          }
          $(chart_div).append(chart);
          var chartData = formatForChartData(data);
          if(chartData.length > 0) {
            renderChart(chart.id, 'pie', sliced_column(column), chartData);
            $.colorbox('height', $('#chartDisplayContainer').height());
          }
          $(ele).addClass('add_border');
        }
        else {
          return {};
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        showMsg('Error: '+ errorThrown, 'danger');
        unblock_screen();
      },
      complete: function(jqXHR, textStatus ){
        chArr = [];
        unblock_screen();
      }
    });
  })
})

function formatForChartData(data) {
  // Create the chart data format for CanvasJS library
  var chartData = new Array;
  for (var k in data) {
    var t = {}
    var legendText = '<div><span style="font-weight:bold;">'+k+'</span>: <span>'+data[k]['sample_count']+'</span></div>';
    t['y'] = parseInt(data[k]['sample_count']);
    t['legendText'] = 'Sample Count';
    t['indexLabel'] = (k == "")? 'NA': k;
    chartData.push(t);
  }
  return chartData;
}
// Function to render chart in a given chart container
function renderChart(chart_div_id, chart_type, title, chartData) {
  var chart = new CanvasJS.Chart(chart_div_id,
  {
    title:{
      text: title
    },
    exportEnabled: true,
    exportFileName: chart_div_id,
    data: [
      {
         type: chart_type,
         // showInLegend: true,
         toolTipContent: title+ ': <strong>{indexLabel}<br></strong>no. of samples: <strong>{y}</strong>',
         dataPoints: chartData,
      }
    ]
  });

  chart.render();
}

