session_pref("xpinstall.whitelist.required", false);
user_pref("extensions.checkCompatibility", false);
homepage = "http://www.google.com/ncr";

require("new-tabs.js");



require("favicon");
add_hook("mode_line_hook", mode_line_adder(buffer_icon_widget), true);
read_buffer_show_icons = true;

xkcd_add_title = true;

require("session.js");
session_auto_save_auto_load = true;

// Set download directory.
cwd = make_file("~/Downloads");

// auto completion in the minibuffer
minibuffer_auto_complete_default = true;
url_completion_use_bookmarks = true;

require("mode-line.js");

// Remove the clock.
remove_hook("mode_line_hook", mode_line_adder(clock_widget));

add_hook("mode_line_hook", mode_line_adder(loading_count_widget), true);
add_hook("mode_line_hook", mode_line_adder(buffer_count_widget), true);

define_webjump("so",    "http://stackoverflow.com/search?q=%s");
define_webjump("nen","http://www.ord.se/oversattning/engelska/?s=%s&l=ENGSVE");
define_webjump("nsv","http://www.ord.se/oversattning/engelska/?s=%s&l=SVEENG");

define_webjump("rss", "http://www.google.com/reader/view/");
define_webjump("khan", "http://www.khanacademy.org/");
define_webjump("github", "https://github.com/Erkaman");
define_webjump("glos", "http://www.glosboken.se/");
define_webjump("blog", "http://whatericlearnedtoday.blogspot.com/");
define_webjump("conk","http://conkeror.org/");
define_webjump("u","http://youtube.com");

define_webjump("c++","http://en.cppreference.com/w/Main_Page");

// load download buffers in the background in the current
// window, instead of in new windows.
download_buffer_automatic_open_target = OPEN_NEW_BUFFER_BACKGROUND;

// passwords.
session_pref("signon.rememberSignons", true);
session_pref("signon.expireMasterPassword", false);
session_pref("signon.SignonFileName", "signons.txt");
Components.classes["@mozilla.org/login-manager;1"]
    .getService(Components.interfaces.nsILoginManager);


//Open middle-clicked links in new buffers
require("clicks-in-new-buffer.js");
clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND; // Now buffers open in background.

function define_global_key(seq,cmd){
    define_key(default_global_keymap,seq,cmd);
}

define_global_key("C-x C-r", "reinit");

define_browser_object_class(
    "history-url", null,
    function (I, prompt) {
        check_buffer (I.buffer, content_buffer);
        var result = yield I.buffer.window.minibuffer.read_url(
            $prompt = prompt,  $use_webjumps = false, $use_history = true, $use_bookmarks = false);
        yield co_return (result);
    });

interactive("find-url-from-history",
            "Find a page from history in the current buffer",
            "find-url",
            $browser_object = browser_object_history_url);

interactive("find-url-from-history-new-buffer",
            "Find a page from history in the current buffer",
            "find-url-new-buffer",
            $browser_object = browser_object_history_url);

define_key(content_buffer_normal_keymap, "h", "find-url-from-history-new-buffer");
define_key(content_buffer_normal_keymap, "H", "find-url-from-history");

// big hint numbers
register_user_stylesheet(
    "data:text/css," +
        escape(
            "@namespace url(\"http://www.w3.org/1999/xhtml\");\n" +
                "span.__conkeror_hint {\n"+
                "  font-size: 14px !important;\n"+
                "  line-height: 14px !important;\n"+
                "}"));


function darken_page (I) {
    var styles='* { background: black !important; color: grey !important; }'+
        ':link, :link * { color: #4986dd !important; }'+
        ':visited, :visited * { color: #d75047 !important; }';
    var document = I.buffer.document;
    var newSS=document.createElement('link');
    newSS.rel='stylesheet';
    newSS.href='data:text/css,'+escape(styles);
    document.getElementsByTagName("head")[0].appendChild(newSS);
}

interactive("darken-page", "Darken the page in an attempt to save your eyes.",
            darken_page);

define_key(content_buffer_normal_keymap, "C-d", "darken-page");

add_hook("window_before_close_hook",
         function () {
             var w = get_recent_conkeror_window();
             var result = (w == null) ||
                 "y" == (yield w.minibuffer.read_single_character_option(
                             $prompt = "Quit Conkeror? (y/n)",
                             $options = ["y", "n"]));
             yield co_return(result);
         });

// Enable caching.
cache_enable(CACHE_ALL);

define_global_key("f7", "caret-mode");

require("reddit");

require("google-search-results");
google_search_bind_number_shortcuts();

define_key(content_buffer_normal_keymap, "l", "follow-new-buffer");

define_variable("firebug_url",
                "http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js");

function firebug (I) {
    var doc = I.buffer.document;
    var script = doc.createElement('script');
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('src', firebug_url);
    script.setAttribute('onload', 'firebug.init();');
    doc.body.appendChild(script);
}
interactive("firebug", "open firebug lite", firebug);

function switch_to_first_buffer(window){
    switch_to_buffer(window,window.buffers.get_buffer(0));
}

interactive("switch-to-first-buffer",
            "switch to the first buffer.",
            function (I) {
                switch_to_first_buffer(I.window);
            });

define_global_key("M-a","switch-to-first-buffer");

function switch_to_last_buffer(window){
    switch_to_buffer(window,window.buffers.get_buffer(window.buffers.count-1));
}

interactive("switch-to-last-buffer",
            "switch to the last buffer.",
            function (I) {
                switch_to_last_buffer(I.window);
            });

define_global_key("M-e","switch-to-last-buffer");

// selection searches
function create_selection_search(webjump, key) {
    interactive(webjump+"-selection-search",
                "Search " + webjump + " with selection contents",
                "find-url-new-buffer",
                $browser_object = function (I) {
                    return webjump + " " + I.buffer.top_frame.getSelection();});
    define_key(content_buffer_normal_keymap, key.toUpperCase(), webjump + "-selection-search");

    interactive("prompted-"+webjump+"-search", null,
                function (I) {
                    var term = yield I.minibuffer.read_url($prompt = "Search "+webjump+":",
                                                           $initial_value = webjump+" ");
                    browser_object_follow(I.buffer, FOLLOW_DEFAULT, term);
                });
    define_key(content_buffer_normal_keymap, key, "prompted-" + webjump + "-search");
}

create_selection_search("google","p");
create_selection_search("wikipedia","w");

url_remoting_fn = load_url_in_new_buffer;

var ref;

interactive("interval-reload", "Reload current buffer every n minutes", function (I) {
                var b = I.buffer;
                var i = yield I.minibuffer.read($prompt="Interval (mm:ss)?");

                if (i.indexOf(":") != -1) {
                    mmss = i.split(":");
                    i = ((parseInt(mmss[0]) * 60) + parseInt(mmss[1])) * 1000;
                } else {
                    i = parseInt(i) * 1000;
                }

                ref = call_at_interval(function () {
                                           reload(b);
                                       }, i);

                add_hook.call(b, "kill_buffer_hook", function() {
                                  ref.cancel();
                              });
            });

interactive("cancel-intervals", "Cancel all running interval reloads", function (I) {
                ref.cancel();
            });

define_global_key("E", "cmd_scrollBottom");
define_global_key("A", "scroll-top-left");

interactive("open-google",
            "Open google",
            "find-url-new-buffer",
            $browser_object = "http://www.google.com/ncr");

define_global_key("C-x C-d", "open-google");