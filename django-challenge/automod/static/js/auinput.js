/*global jQuery*/
/*jslint nomen: true */
jQuery(function ($) {
    'use strict';
    $.widget('my.auinput', {

        options: {
            table: '',
            rowid: 0,
            field: {
                name: '',
                type: '',
                value: '',
            },
        },

        _create: function() {
            var self = this;

            if(this.options.field.type === 'auto') {
                this.element.append($('<span/>', {text: this.options.field.value}));
            } else {
                this.element.append(
                    $('<form/>', {
                        action: '/api/',
                        role: 'form',
                        style: 'margin-bottom: 0;'
                    }).append(
                        $('<div/>', {
                            'class': 'form-group',
                            style: 'margin-bottom: 0;'
                        }).append(
                            $('<input/>', {
                                name: 'value',
                                value: this.options.field.value,
                                'class': 'form-control',
                                readonly: true
                            }))));
                $(this.element).find('form').validate({
                    submitHandler: function(form) {
                        $(form).ajaxSubmit({
                            method: 'PUT',
                            data: {
                                table: self.options.table,
                                id: self.options.rowid,
                                field: self.options.field.name,
                            },
                            success: function(data) {
                                if (data.success) {
                                    self.options.field.value = data.value;
                                }
                            }
                        });
                    }
                });
                $(this.element).find('input').rules('add', {required: true});
                if(this.options.field.type === 'int') {
                    $(this.element).find('input').rules('add', {digits: true});
                } else if (this.options.field.type === 'date') {
                    $(this.element).find('input').rules('add', {dateISO: true});
                }
            }

            this._createHandlers();
        },

        _createHandlers: function() {
            var self = this;
            $(this.element).on('click focusin', 'input', function(ev) {
                if(self.options.field.type === 'date') {
                    $(this).datepicker();
                }
                if (ev.type === 'click') {
                    $(this).focus();
                }
                if($(this).is(':focus') || (ev.type === 'focusin')) {
                    $(this).prop('readonly', false);
                }
            });

            $(this.element).find('input').hover(
                function() { $(this).css('cursor', 'text');},
                function() { $(this).css('cursor', 'auto');}
            );

            $(this.element).on('focusout', 'input', function() {
                if(self._valid()) {
                    $(this).prop('readonly', true);
                } else {
                    $(this).focus();
                }
            });

            $(this.element).on('change', 'input', function() {
                $(self.element).find('form').submit();
            });
        },

        _valid: function() {
            return $(this.element).find('form').validate().form();
        }
   });
});
