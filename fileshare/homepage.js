/*global document,alert,FormData,XMLHttpRequest,JSON*/
function show_progress(filename, progress) {
    'use strict';

    var span = document.getElementById('progress');
    if(progress === 100) {
        span.innerHTML = '<a href="' + filename + '">' + filename + '</a>';
    } else {
        span.innerHTML = progress + '%';
    }
}


function check_progress(filename) {
    'use strict';

    return function() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/?name=' + filename);
        xhr.send();
        xhr.onreadystatechange = function() {
            var data;
            if (xhr.readyState !== 4) {
                return;
            }
            if (xhr.status !== 200) {
                alert(xhr.status + ': ' + xhr.statusText);
            } else {
                data = JSON.parse(xhr.responseText);
                show_progress(filename, data.progress);
                if(data.progress !== 100) {
                    setTimeout(check_progress(filename), 2 * 100);
                }
            }
        };
    };
}


function post_form() {
    'use strict';

    var formData = new FormData(document.forms.upload),
        filename = document.getElementsByName('file')[0].files[0].name,
        xhr = new XMLHttpRequest();
    xhr.open('POST', '/', true);
    xhr.send(formData);
    xhr.onreadystatechange = function() {
        var data;
        if (xhr.readyState !== 4) {
            return;
        }
        if (xhr.status !== 200) {
            alert(xhr.status + ': ' + xhr.statusText);
        } else {
            data = JSON.parse(xhr.responseText);
            show_progress(filename, data.progress);
        }
    };
    return filename;
}


document.forms.upload.onsubmit = function() {
    'use strict';

    var filename = post_form();
    check_progress(filename)();
    return false;
};
