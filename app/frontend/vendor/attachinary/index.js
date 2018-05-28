(function($) {
  $.attachinary = {
    index: 0,
    config: {
      disableWith: 'Chargement...',
      indicateProgress: true,
      invalidFormatMessage: 'Format de fichier invalide',
      template:
        '\
        <% for(var i=0; i<files.length; i++){ %>\
          <div>\
            <% if(files[i].resource_type == "raw") { %>\
              <div class="raw-file"></div>\
            <% } else if (files[i].format == "mp3") { %>\
              <audio src="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "resource_type": "video", "format": "mp3"}) %>" controls />\
            <% } else { %>\
              <img\
                src="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "format": "jpg", "crop": "fill", "width": 240, "height": 180 }) %>"\
                alt="" width="240" height="180" />\
            <% } %>\
            <a href="#" data-remove="<%= files[i].public_id %>">×</a>\
          </div>\
        <% } %>\
    ',
      render: function(files) {
        return $.attachinary.Templating.template(this.template, {
          files: files
        });
      }
    }
  };
  $.fn.attachinary = function(options) {
    var settings;
    settings = $.extend({}, $.attachinary.config, options);
    return this.each(function() {
      var $this;
      $this = $(this);
      if (!$this.data('attachinary-bond')) {
        return $this.data(
          'attachinary-bond',
          new $.attachinary.Attachinary($this, settings)
        );
      }
    });
  };
  $.attachinary.Attachinary = class Attachinary {
    constructor($input1, config) {
      var ref;
      this.$input = $input1;
      this.config = config;
      this.options = this.$input.data('attachinary');
      this.files = this.options.files;
      this.$form = this.$input.closest('form');
      this.$submit = this.$form.find(
        (ref = this.options.submit_selector) != null
          ? ref
          : 'input[type=submit]'
      );
      if (this.options.wrapper_container_selector != null) {
        this.$wrapper = this.$input.closest(
          this.options.wrapper_container_selector
        );
      }
      this.initFileUpload();
      this.addFilesContainer();
      this.bindEventHandlers();
      this.redraw();
      this.checkMaximum();
    }

    initFileUpload() {
      var options;
      this.options.field_name = this.$input.attr('name');
      options = {
        dataType: 'json',
        paramName: 'file',
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        },
        dropZone: this.config.dropZone || this.$input,
        sequentialUploads: true
      };
      if (this.$input.attr('accept')) {
        options.acceptFileTypes = new RegExp(
          `^${this.$input
            .attr('accept')
            .split(',')
            .join('|')}$`,
          'i'
        );
      }
      return this.$input.fileupload(options);
    }

    bindEventHandlers() {
      this.$input.bind('fileuploadsend', (event, data) => {
        this.$input.addClass('uploading');
        if (this.$wrapper != null) {
          this.$wrapper.addClass('uploading');
        }
        this.$form.addClass('uploading');
        this.$input.prop('disabled', true);
        if (this.config.disableWith) {
          this.$submit.each((index, input) => {
            var $input;
            $input = $(input);
            if ($input.data('old-val') == null) {
              return $input.data('old-val', $input.val());
            }
          });
          this.$submit.val(this.config.disableWith);
          this.$submit.prop('disabled', true);
        }
        return !this.maximumReached();
      });
      this.$input.bind('fileuploaddone', (event, data) => {
        return this.addFile(data.result);
      });
      this.$input.bind('fileuploadstart', event => {
        // important! changed on every file upload
        return (this.$input = $(event.target));
      });
      this.$input.bind('fileuploadalways', event => {
        this.$input.removeClass('uploading');
        if (this.$wrapper != null) {
          this.$wrapper.removeClass('uploading');
        }
        this.$form.removeClass('uploading');
        this.checkMaximum();
        if (this.config.disableWith) {
          this.$submit.each((index, input) => {
            var $input;
            $input = $(input);
            return $input.val($input.data('old-val'));
          });
          return this.$submit.prop('disabled', false);
        }
      });
      return this.$input.bind('fileuploadprogressall', (e, data) => {
        var progress;
        progress = parseInt(data.loaded / data.total * 100, 10);
        if (this.config.disableWith && this.config.indicateProgress) {
          return this.$submit.val(`[${progress}%] ${this.config.disableWith}`);
        }
      });
    }

    addFile(file) {
      if (
        !this.options.accept ||
        $.inArray(file.format, this.options.accept) !== -1 ||
        $.inArray(file.resource_type, this.options.accept) !== -1
      ) {
        this.files.push(file);
        this.redraw();
        this.checkMaximum();
        return this.$input.trigger('attachinary:fileadded', [file]);
      } else {
        return alert(this.config.invalidFormatMessage);
      }
    }

    removeFile(fileIdToRemove) {
      var _files, file, i, len, ref, removedFile;
      _files = [];
      removedFile = null;
      ref = this.files;
      for (i = 0, len = ref.length; i < len; i++) {
        file = ref[i];
        if (file.public_id === fileIdToRemove) {
          removedFile = file;
        } else {
          _files.push(file);
        }
      }
      this.files = _files;
      this.redraw();
      this.checkMaximum();
      return this.$input.trigger('attachinary:fileremoved', [removedFile]);
    }

    checkMaximum() {
      if (this.maximumReached()) {
        if (this.$wrapper != null) {
          this.$wrapper.addClass('disabled');
        }
        return this.$input.prop('disabled', true);
      } else {
        if (this.$wrapper != null) {
          this.$wrapper.removeClass('disabled');
        }
        return this.$input.prop('disabled', false);
      }
    }

    maximumReached() {
      return this.options.maximum && this.files.length >= this.options.maximum;
    }

    addFilesContainer() {
      if (
        this.options.files_container_selector != null &&
        $(this.options.files_container_selector).length > 0
      ) {
        return (this.$filesContainer = $(
          this.options.files_container_selector
        ));
      } else {
        this.$filesContainer = $('<div class="attachinary_container">');
        return this.$input.after(this.$filesContainer);
      }
    }

    redraw() {
      this.$filesContainer.empty();
      if (this.files.length > 0) {
        this.$filesContainer.append(
          this.makeHiddenField(JSON.stringify(this.files))
        );
        this.$filesContainer.append(this.config.render(this.files));
        this.$filesContainer.find('[data-remove]').on('click', event => {
          event.preventDefault();
          return this.removeFile($(event.target).data('remove'));
        });
        return this.$filesContainer.show();
      } else {
        this.$filesContainer.append(this.makeHiddenField(null));
        return this.$filesContainer.hide();
      }
    }

    makeHiddenField(value) {
      var $input;
      $input = $('<input type="hidden">');
      $input.attr('name', this.options.field_name);
      $input.val(value);
      return $input;
    }
  };
  // JavaScript templating by John Resig's
  return ($.attachinary.Templating = {
    settings: {
      start: '<%',
      end: '%>',
      interpolate: /<%=(.+?)%>/g
    },
    escapeRegExp: function(string) {
      return string.replace(/([.*+?^${}()|[\]\/\\])/g, '\\$1');
    },
    template: function(str, data) {
      var c, endMatch, fn;
      c = this.settings;
      endMatch = new RegExp(
        "'(?=[^" + c.end.substr(0, 1) + ']*' + this.escapeRegExp(c.end) + ')',
        'g'
      );
      fn = new Function(
        'obj',
        'var p=[],print=function(){p.push.apply(p,arguments);};' +
          "with(obj||{}){p.push('" +
          str
            .replace(/\r/g, '\\r')
            .replace(/\n/g, '\\n')
            .replace(/\t/g, '\\t')
            .replace(endMatch, '✄')
            .split("'")
            .join("\\'")
            .split('✄')
            .join("'")
            .replace(c.interpolate, "',$1,'")
            .split(c.start)
            .join("');")
            .split(c.end)
            .join("p.push('") +
          "');}return p.join('');"
      );
      if (data) {
        return fn(data);
      } else {
        return fn;
      }
    }
  });
})(jQuery);
