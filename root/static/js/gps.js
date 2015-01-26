    var loadedData;
    var dg_searched = false;
    var myNav = navigator.userAgent.indexOf('msie');
    if (myNav > 0) {
      var str = 'You are using an incompatible browser. Please use latest version of Firefox or Chrome';
      showMsg(str, 'danger');
    }
    function showMsg(msg,type){
      return $.bootstrapGrowl(msg, { type: type});
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
      }

      init = (fl=="search")? false : true; // If search clicked, then it is no more an initial load. So set it false
      // Main data grid initialization
      var dg = $('#dg').edatagrid({
        url: base_request_url + '/gps/json/search',
        columns: [dgcolumns],
        method: 'post',
        queryParams: (dg_searched)? {data: JSON.stringify(inpObj)}:'',
        iconCls: 'icon-search',
        singleSelect: false,
        remoteSort: true,
        fit: true,
        height: $(window).height()-85,
        //sortName: 'gsd_public_name',
        //sortOrder: 'desc',
        rowStyler: function(index,row){
          if (row.grs_decision == 0 && row.grs_decision != ""){
            return 'color:#cc0000;'; // return inline style
            // the function can return predefined css class and inline style
            // return {class:'r1', style:{'color:#fff'}}; 
          }
          else if (row.grs_decision == -1 && row.grs_decision != ""){
            return 'font-weight:bold;color:teal'; // return inline style
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
                str : 'Error occured while fetching data from the server!',
                title: 'Error!'
            });
        },
        onLoadSuccess:function(data){
          if(data && data.err) {
            showMsg(data.err,'danger');
          }
          if(data && data.total == 0) {
            showMsg('No data found!')
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

          // inititialize decision and comments as they are not found in the rowData
          // So that it works while checking for any row edits in 'onAfterEdit'
          if(!rowData.grs_decision) {
            rowData.grs_decision = "";
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
            t['grs_comments'] = rowData.grs_comments;
            t['grs_in_silico_st'] = rowData.grs_in_silico_st;
            t['grs_in_silico_serotype'] = rowData.grs_in_silico_serotype;
            chArr.push(t);
          }
          else {
            //console.log('No change');
          }
        },
        onError: function(index,row){
          showMsg('Error'+index,'danger');
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
          title: 'My Dialog',
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
        });  //end confirm dialog            return false;
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
          },
          complete: function(){
            $('#dg').datagrid('reload');
            chArr = [];
          }
        });
        chArr = [];
      }
    }

    /*
      Export data as CSV/XML based on row selected/ search / none=download all
    */
    var init = true;
    var export_clicked = false;
    var exportData = function(extn) {
      if(!export_clicked) {

        // Get selected columns if any
        var chkdArr = $('#dg').datagrid('getChecked');
        var qdata = {};
        var url = '';

        // Creating the query string to be passed via POST
        // If row selected
        if(chkdArr.length <= 0) {
          if(dg_searched) {
            var inpObj = $('.niceform').serializeObject();
            qdata = {'data': JSON.stringify(inpObj)};
          }
          else {
            qdata = "";
          }
          url = base_request_url + '/gps/json/download';
        }
        else {
          url = base_request_url + '/gps/json/download_selected';
          var arr = new Array();
          // Decision flag is used to check if the selected row has been excluded or not. Excluded data are not given for download
          // Currently allowing all download. So below statement is set to false
          var all_decision_0 = false;
          jQuery.each(chkdArr, function(ind, row) {
            // if(row.grs_decision != 0){
            //   all_decision_0 = false;
            // }
            var t = {};
            t['gss_sanger_id'] = row.gss_sanger_id;
            arr.push(t);
          })
          if(all_decision_0) {
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

        showMsg('Downloading data...', 'success')
        export_clicked = true;
        $.ajax({
          url: url,
          type: 'POST',
          // If not initial loading, then donot pass form objects as user need to download all data
          data: qdata,
          dataType: 'JSON',
          success: function(data) {
            if(data.err) {
              showMsg('Error: '+ data.err, 'danger');
              export_clicked = false;
              return false;
            }
            (extn == "xml")?JSONtoXML(data):JSONtoCSV(data);
            fl = 'search';
            export_clicked = false;
            return false;
          },
          error: function(jqXHR, textStatus, errorThrown) {
            showMsg('Error: '+ errorThrown, 'danger');
            export_clicked = false;
            return false;
          }
        });
        return false;
      }
      else {
        showMsg('Export request already initiated. Please wait...');
      }
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

// console.log(xml)
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
    var updataDecision = function(val) {
      $('#dg').edatagrid('acceptChanges');
      var chkdArr = $('#dg').datagrid('getChecked');
      var arr = new Array();
      jQuery.each(chkdArr, function(ind, row) {
        var t = {};
        t['gss_sanger_id'] = row.gss_sanger_id;
        t['gss_lane_id'] = row.gss_lane_id;
        t['gss_public_name'] = row.gss_public_name;
        arr.push(t);
      })

      if(arr.length) {
        $.ajax({
          url: base_request_url + '/gps/update/decision',
          type: 'POST',
          cache:false,
          data: {
            'data' : JSON.stringify(arr),
            'type' : val
          },
          dataType: 'JSON',
          success: function(data, textStatus, jqXHR) {
            if(data && data.err) {
              var str = "Error: " + data.err + "<br>Message:" + data.errMsg
              showMsg(str,'danger');
            }
            else if(data.success) {
              showMsg( '<em>' + data.success.final_sample_outcome + '</em>' + ' <br>( ' + data.success.rows + ((data.success.rows > 1)?' rows':' row') + ' updated )','success');
            }
          },
          error: function(jqXHR, textStatus, errorThrown) {
            showMsg('Error: '+ errorThrown, 'danger');
          },
          complete: function(jqXHR, textStatus ){
            $('#dg').datagrid('reload');
            chArr = [];
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
          html_str += '<option value='+ value +'>' + value.slice(4).replace(/_/g,' ') + '</option>';
        });
      })
      html_str += '</optgroup>';
      return html_str;
    }

    var gpsdb_column_2d_array = new Object();
    var gpsdb_column_1d_array = new Array();
    var dgcolumns = new Array();
    var editable_columns = new Array();
    editable_columns = ['grs_comments', 'grs_in_silico_st', 'grs_in_silico_serotype'];
    var visible_columns = new Array();
    visible_columns = ['gss_sanger_id', 'gss_public_name', 'gss_lane_id', 'gsd_total_length', 'gss_total_yield', 'grs_comments' ];
    var exclude_columns = new Array();
    exclude_columns = [];

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
                    </select><br>\
                    <textarea name="search_str" id="search_str" rows="3" cols="35" placeholder="Paste your input here... Multiple entries should be separated by a newline character"></textarea>\
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


    // Create column fields with necessary attributes for the datagrid.
    // This controls the edit permission for admin, show / hide of columns etc.
    // Returns an object with its properties for a single column that is passed as argument
    var createColumnFieldsForDatagrid = function(column_name)
    {
      var t = {};
      t['field'] = column_name;
      t['title'] = column_name.slice(4).replace(/_/g,' ');
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

          if(elem[i].name == "columns" || elem[i].name == "eq") {
            temp[elem[i].name] = elem[i].value;
          }
          else if(elem[i].name == "search_str") {
            // Replace textarea string breaks with comma
            var str = elem[i].value.replace(/\n|\r|\n\r|\r\n/g,',');
            temp[elem[i].name] = str.replace(/^,+|,+$/, "");
            temp[elem[i].name] = str.replace(/,+/g, ",");
          }
          field_count++;
          if(field_count === 3) {
            obj.push([temp]);
            temp = {};
            field_count = 0;
          }
        }
        return obj;
    };

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

/*
  var drag_col_selected = new Array();

  $(document).ready(function(){
    $('.item').click(function () {
      if($(this).hasClass('col_selected')) {
        var idx = drag_col_selected.indexOf(this.id);
        if (idx != -1) {
          drag_col_selected.splice(idx, 1); // The second parameter is the number of elements to remove.
          $(this).addClass('col_selected');
          $(this).css('background', '#eee');
          return false;
        }
      }

      $(this).addClass('col_selected');
      drag_col_selected.push(this.id);
      $(this).css('background', '#c6dcff');
      return false;
    });
    $('.item').draggable({
        revert:true,
        proxy:function(source){
            var n = $('<div class="proxy"></div>');
            n.html($(source).html()).addClass('drag').appendTo('body').hide(150);
            return n;
        },
        onStartDrag:function(){
            $(this).draggable('options').cursor = 'not-allowed';
            $(this).draggable('proxy').css('z-index',15);
            // For enabling click event select. Hide here and show on onDrag
            $(this).draggable('proxy').hide();
        },
        onDrag: function(){
           $(this).draggable('proxy').show();
        },
        onStopDrag:function(){
            $(this).draggable('options').cursor='move';
        },
        onBeforeDrag:function(event){
        }
    });
    $('.drop-div').droppable({
        onDragEnter:function(e,source){
            $(source).draggable('options').cursor='auto';
        },
        onDragLeave:function(e,source){
            $(source).draggable('options').cursor='not-allowed';
        },
        onDrop:function(e,source){
            addColumn(source.id,true);
        }
    });
  })
*/

  $(document).ready(function(){
    $('.item').click(function () {
      // Based on class assignment, find out of it has 
      if(!$(this).hasClass('add_border')) {
        $('#dg').datagrid('showColumn',this.id);
        $(this).addClass('add_border');
        // Making datagrid column field visible
        change_dgcolumns_hidden_property(this.id, true);
      }
      else {
        $('#dg').datagrid('hideColumn',this.id);
        $(this).removeClass('add_border');
        // Making datagrid column field hidden
        change_dgcolumns_hidden_property(this.id, false);
      }
      return false;
    });

    $('.showAll').click(function () {
      $.each(dgcolumns, function(ind, val) {
        $('#dg').datagrid('showColumn',val.field);
        $('.item').addClass('add_border');
        // Making datagrid column field visible
        change_dgcolumns_hidden_property(val.field, true);
      });
    });
    $('.hideAll').click(function () {
      $.each(dgcolumns, function(ind, val) {
        if(val.field != 'ck') {
          $('#dg').datagrid('hideColumn',val.field);
          $('.item').removeClass('add_border');
          // Making datagrid column field visible
          change_dgcolumns_hidden_property(val.field, false);
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


/*

  // Adding = show column in the datagrid
  function addColumn(id, add_fl) {
    var col_arr = new Array();
    // If single column drag, then convert it to an array and then go forward
    if(typeof id == "string") {
      col_arr.push(id);
    }
    else {
      col_arr = id;
    }
    var flag = 0;
    var reload_needed = false;
    for(var i=0; i<col_arr.length; i++) {
      if(add_fl) {
        $('#dg').datagrid('showColumn', col_arr[i]);
      }
      else {
        $('#dg').datagrid('hideColumn', col_arr[i]);
      }

      $.each(dgcolumns, function(ind, val) {
        if(val.field == col_arr[i]) {
          val.hidden = (add_fl)?false:true;
        }
      })
    }
    */
/*
    // Reload datagrid if necessary
    if(reload_needed) {
      var dg = $('#dg');

      console.log(loadedData);
      dg.datagrid('showColumn', );
      //dg.datagrid('loadData', loadedData);
    }
*/
    // Change background color of the selected columns
    // changeBackgroundSelected();

    // Unload the array
    // drag_col_selected = [];
  // }
/*
  // Handle multiple select
  $(document).ready(function(){
    $('.add_selected').click(function(){
        addColumn(drag_col_selected, true);
    });    
    $('.remove_selected').click(function(){
        addColumn(drag_col_selected, false);
    });
  });
*/
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
    $('.draggable').html('<ul></ul>');
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
        $('.draggable ul').append(li);
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

  var download_clicked = false;

  function downloadFastq() {
    // http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=ERS221588&result=read_run&fields=fastq_ftp
    if(download_clicked) {
      showMsg('A download is in progress... Please wait')
      return;
    }
    // To avoid second click on the link
    download_clicked = true;
    checkIfDataEdited();
    $('#dg').edatagrid('acceptChanges');
    var chkdArr = $('#dg').datagrid('getChecked');
    var arr = new Array();
    $.each(chkdArr, function(ind, row) {
      arr.push(row.gsd_err);
    });
    var msg;
    if(arr.length <= 0) {
      showMsg('Please select a sample!');
      download_clicked = false;
      return;
    }
    else {
      msg = showMsg('Fetching fastq URLs...');
    }
    var url = base_request_url + '/fastq/url/';
    $.ajax({
      url: url,
      data: {
        'accession' : arr,
        'type' : 'fastq_ftp'
      },
      type: 'POST',
      dataType: 'json',
      success: function(data, textStatus, jqXHR) {
        if(Object.keys(data).length) {
          var html = createFastqHTMLStr(data)
          $.colorbox({
            html: html,
            maxHeight: $('#layout').height() * 0.8,
            maxWidth: $('#layout').width() * 0.8
          });
        }
        else {
          showMsg('Fastq not found!')
        }
        download_clicked = false;
      },
      error: function(jqXHR, textStatus, errorThrown) {
        showMsg('Error: '+ errorThrown, 'danger');
        $('.fastqlink').unbind('click', false);
        download_clicked = false;
      },
      complete: function(jqXHR, textStatus ){
        $('.fastqlink').unbind('click', false);
        download_clicked = false;
        chArr = [];
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

    $('.update_st_form_container').slideDown();

  }
  
  function st_update_validator() {
    if($('#st_update_file').val() == "") {
      showMsg('Please select your file to upload!');
      return false;
    }
    var reg = /\.xlsx$/;
    if(!reg.test($('#st_update_file').val())) {
      showMsg('Invalid file. Only .xlsx files are valid!');
      return false;
    }
    if($("input[name='st_update_type']:checked").val() == undefined) {
      showMsg('Please select the type of data you are uploading!');
      return false;
    }
    return true;
  }

  // ST bulk update function
  (function() {

    $('.update_st_form').ajaxForm({
      resetForm: true,
      beforeSubmit: st_update_validator,
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
        $('.update_st_form_container').slideUp();
      }
    });

  })(); 
  window.onload = function() {
    setTimeout(function(){document.getElementById('block_screen').style.display = 'none';},1000);
  }


  function downloadZipFiles(type) {
    if(download_clicked) {
      showMsg('A download is in progress... please wait')
      return;
    }
    // To avoid second click on the link
    download_clicked = false;
    checkIfDataEdited();
    $('#dg').edatagrid('acceptChanges');
    var chkdArr = $('#dg').datagrid('getChecked');
    var arr = new Array();
    $.each(chkdArr, function(ind, row) {
      // Push only if lane id is present
      if(row.gss_lane_id != "" && row.gss_lane_id != undefined && row.grs_decision != 0 )
        arr.push(row.gss_lane_id);
    });

    var msg;
    var str = '';
    if(chkdArr.length <= 0) {
      // No selection made
      showMsg('Please select a sample!');
      download_clicked = false;
      return;
    }
    else if(arr.length <= 0) {
      // Lane id not found
      showMsg('Download not available for the selected samples!');
      download_clicked = false;
      return;
    }
    else {
      msg = showMsg('Fetching data...');
      if(arr.length >= 100) {
        showMsg('More number of '+type+' to download. Please wait while we compress the files...')
      }
    }
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
        download_clicked = false;
      },
      error: function(jqXHR, textStatus, errorThrown) {
        showMsg('Error: '+ errorThrown, 'danger');
        $('.fastqlink').unbind('click', false);
        download_clicked = false;
      },
      complete: function(jqXHR, textStatus ){
        $('.fastqlink').unbind('click', false);
        download_clicked = false;
        chArr = [];
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



