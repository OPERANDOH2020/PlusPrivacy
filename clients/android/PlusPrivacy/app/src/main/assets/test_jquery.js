(function() {

    if ('undefined' == typeof window.jQuery) {
        // jQuery is not loaded
        Android.isLoaded(0);
    } else {
        // jQuery is loaded
        Android.isLoaded(1);
    }
})();