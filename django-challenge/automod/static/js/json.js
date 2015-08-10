/*global jQuery*/
/*jslint nomen: true */
jQuery(function($) {
    'use strict';

    function _build_header(data) {
        var header = [];
        $.each(data, function(_, f) {
            header.push('<th id="' + f.id + '">' + f.title + '</th>');
        });
        $('<tr/>', {html: header.join('')}).appendTo('table');
    }

    function _build_body(table, data) {
        $.each(data.rows, function(_, r) {
            var tr = $('<tr/>', {'class': 'dataRow'});
            $.each(data.fields, function(_, f) {
                        $('<td/>', {'class': f.id + 'Cell'}).auinput({
                            table: table,
                            rowid: r.id,
                            field: {name: f.id, value:r[f.id], type: f.type}
                        }).appendTo(tr);
            });
            tr.appendTo('table');
        });
    }

    function _build_form(form, data) {
        var rules = {};
        $.each(data.fields, function(_, f) {
            if (f.type === 'auto') {
                return;
            }
            rules[f.id] = {required: true};
            if (f.type === 'int') {
                rules[f.id].digits = true;
            } else if (f.type === 'date') {
                rules[f.id].dateISO = true;
            }

            form.append(
                    $('<div/>', {'class': 'form-group'}).append(
                        $('<label/>', {
                            text: f.title,
                            'class': 'control-label col-sm-3',
                        })).append($('<div/>', {'class': 'col-sm-7'}).append(
                        $('<input/>', {
                            name: f.id,
                            id: f.id + 'Input',
                            'ftype': f.type,
                            'class': 'form-control'
                        }))));
        });

        form.append(
            $('<div/>', {'class': 'form-group'}).append(
                $('<div/>', {'class': 'col-sm-offset-3 col-sm-7'}).append(
                    $('<button/>', {
                        type: 'submit',
                        'class': 'btn btn-primary',
                        text: 'Добавить'}))));
        return rules;
    }


    function csrfSafeMethod(method) {
        return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
    }
    $.ajaxSetup({
        beforeSend: function(xhr, settings) {
            if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
                xhr.setRequestHeader('X-CSRFToken', $.cookie('csrftoken'));
            }
        }
    });

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd'
    });

    $('a.tname').on('click', function() {
        $('form').removeData('validate');
        $('table').html('');
        $('#newItemForm').html('');
        var table = $(this).prop('name');
        $.ajax({
            url: '/api/',
            data: {table: table},
            success: function(data) {
                _build_header(data.fields);
                _build_body(table, data);
                var rules = _build_form($('#newItemForm'), data);
                $('form').on('focusin', 'input[ftype=date]', function() {
                    $(this).datepicker();
                });
                $('#newItemForm').validate({
                    rules: rules,
                    submitHandler: function(form) {
                        $(form).ajaxSubmit({
                            data: {table: table, csrftoken: $.cookie('csrftoken')},
                            success: function(data) {
                                if (data.length !== 0) {
                                    _build_body(table, data);
                                    $(form).resetForm();
                                }
                            }
                        });
                    }
                });
            }
        });
    });
});

