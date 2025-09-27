function scheduleNotification(title, body, secondsFromNow) {
   window.webkit.messageHandlers.scheduleNotification.postMessage({
       title: title,
       body: body,
       time: secondsFromNow
   });
}
