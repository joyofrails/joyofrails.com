---
title: Using Web Push Notifications with VAPID
author: Ross Kaffenberger
published_at: 2016-10-21
summary: Sending push notifications in Ruby or Node.js on the open web
description: Sending push notifications in Ruby or Node.js on the open web using the Voluntary Application server Identification (VAPID) protocol.
layout: article
thumbnail: 'blog/stock/horsehead-nebula-pexels-photo.jpeg'
series: Service Worker
category: Code
tags:
  - Ruby
  - JavaScript
  - Service Worker
---

Push messages from mobile and desktop browsers are [now a thing](http://caniuse.com/#feat=push-api) on the open web.

Why use the Push API? It allows us to use free, third-party services to notify our users
of events, even when they're not actively engaged with our site. It's
not meant to replace other methods of pushing data to clients, like
[WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) or [Server Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events), but can be useful for sending small, infrequent payloads to keep users engaged. Think: a build has finished successfully, a new post was published, a touchdown was scored. What's
common place on our smartphones from installed apps is now possible from the browser.

[[Push message in Chrome](screenshots/screenshot-sw-sandbox-push-simple-3.jpg)](https://serviceworker-rails.herokuapp.com/push-simple/)

Though only supported in Chrome and Firefox on the desktop and in Chrome on Android at the time of this writing, it'll be more widespread soon enough. While I previously [wrote about this topic](/blog/web-push-notifications-from-rails.html), there have been recent changes in the Chrome implementation to make the API consistent with Firefox, which we'll describe here.

In this post, we'll walk through setting up a Ruby or Node.js web application to use the Push API with the [Voluntary Application server Identification (VAPID)](https://tools.ietf.org/html/draft-ietf-webpush-vapid-01). Use of VAPID for push requests is optional, but primarily a security benefit. Application servers use VAPID to identify themselves to the push servers so push subscriptions can be properly restricted to their origin app servers. In other words, VAPID could theoretically prevent an attacker from stealing a user `PushSubscription` and sending push messages to that recipient from another server. Down the road, push services may be able to provide analytics and debugging assistance for app servers using the VAPID protocol. Another benefit: in Chrome, it is no longer necessary to register our web apps through the Google Developer Console and pass around Google app credentials in web push requests.

## Overview

There are three parties involved in delivering a push message.

- Your application server
- Your user
- A push server, e.g., Google or Mozilla

Before a push message can be delivered with VAPID, a few criteria should be satisfied:

1. Your application server has generated a set of VAPID keys that will be used to sign Push API requests. This is a one-time step (at least until we decide to reset the keys).
2. A `manifest.json` file, linked from a page on our website, identifies our app settings.
3. In the user's web browser, a service worker script is installed and activated. The `pushManager` property of the `ServiceWorkerRegistration` is subscribed to push events with our VAPID public key, with creates a `subscription` JSON object on the client side.
4. Your server makes an API request to a push server (likely using a server-side library) to send a notification with the `subscription` obtained from the client and an optional payload (the message).
5. Your service worker is set up to receive `'push'` events. To trigger a desktop notification, the user has accepted the prompt to receive notifications from our site.

## Generating VAPID keys

To take advantage of the VAPID protocol, we would generate a public/private VAPID key pair to store on our server to be used for all user subscriptions.

In Ruby, we can use the `webpush` gem to generate a VAPID key that has both a `public_key` and `private_key` attribute to be saved on the server side.

```ruby
# Gemfile
gem 'webpush'
```

In a Ruby console:

```ruby
require 'webpush'

# One-time, on the server
vapid_key = Webpush.generate_key

# Save these in our application server settings
vapid_key.public_key
# => "BC1mp...HQ="

vapid_key.private_key
# => "XhGUr...Kec"
```

In Node.js, we can use the `web-push` package:

```bash
npm install web-push --save
```

In the node REPL:

```javascript
const webpush = require('web-push');

const vapidKeys = webpush.generateVAPIDKeys();

vapidKeys.publicKey;
('BDO0P...eoH');

vapidKeys.privateKey;
('3J303..r4I');
```

The keys returned will both be Base64-encoded byte strings. Only the public key
will be shared, both with the user's browser and the push server as we'll see
later.

## Declaring manifest.json

Add a `manifest.json` file served at the scope of our app (or above), like at the root to describe our client application for use with the Push API.

```javascript
{
"name": "My App",
  "short_name": "my-app",
  "start_url": "/",
  "icons": [
  {
    "src": "/images/my-push-logo-192x192.png",
    "sizes": "192x192",
    "type": "image/png"
  }
  ]
}
```

Link to it somewhere in the `<head>` tag:

```html
<!-- index.html -->
<link rel="manifest" href="/manifest.json" />
```

## Installing a service worker

Your application javascript must register a service worker script at an appropriate scope (we're sticking with the root).

```javascript
// application.js
// Register the serviceWorker script at /serviceworker.js from our server if supported
if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js').then(function (reg) {
    console.log('Service worker change, registered the service worker');
  });
}
// Otherwise, no push notifications :(
else {
  console.error('Service worker is not supported in this browser');
}
```

For Rails developers, we may want to look at the [`serviceworker-rails` gem](https://github.com/rossta/serviceworker-rails) and this [helpful tutorial](https://rossta.net/blog/service-worker-on-rails.html) to integrate service worker scripts with the Rails asset pipeline.

## Subscribing to push notifications

The VAPID public key we generated earlier is made available to the client as a `Uint8Array`. To do this, one way would be to expose the urlsafe-decoded bytes from Ruby to JavaScript when rendering the HTML template.

In Ruby, we might embed the key as raw bytes from the application `ENV` or some other application settings mechanism into an HTML template with help from the `Base64` module in the standard library. Global variables are used here for simplicity.

```ruby
# server
@decodedVapidPublicKey = Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY']).bytes
```

```html
<!-- html template -->
<script>
  window.vapidPublicKey = new Uint8Array(<%= @decodedVapidPublicKey %>);
</script>
```

In Node.js, we could use the `urlsafe-base64` package to decode the public key and convert it to raw bytes:

```javascript
// server
const urlsafeBase64 = require('urlsafe-base64');
const decodedVapidPublicKey = urlsafeBase64.decode(process.env.VAPID_PUBLIC_KEY);
```

```html
<!-- html template -->
<script>
  window.vapidPublicKey = new Uint8Array(<%= decodedVapidPublicKey %>);
</script>
```

Your application javascript would then use the `pushManager` property to subscribe to push notifications, passing the VAPID public key to the subscription settings.

```javascript
// application.js
// When serviceWorker is supported, installed, and activated,
// subscribe the pushManager property with the vapidPublicKey
navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.vapidPublicKey,
  });
});
```

## Triggering a web push notification

The web push library we're using on the backend will be responsible for
packaging up the request to the subscription's endpoint and handling encryption, so the user's push subscription must be sent from the client to the application server at some point.

In the example below, we send the JSON generated subscription object to our backend with a message when a button on the page is clicked.

```javascript
// application.js
$('.webpush-button').on('click', (e) => {
  navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager.getSubscription().then((subscription) => {
      $.post('/push', {
        subscription: subscription.toJSON(),
        message: 'You clicked a button!',
      });
    });
  });
});
```

The call to `pushManager.getSubscription()` returns a Promise that provides the
`PushSubscription` instance with all the information the push service needs to
send a push message to this user's browser. This includes an `endpoint`, the URL
on the push server where we'll send the push request, and a pair of `keys`
labelled as `p256dh` and `auth` required to encrypt the push message payload. If interested to learn more about how this encryption works, check out this detailed summary on [web push payload encryption](https://developers.google.com/web/updates/2016/03/web-push-encryption).

```javascript
// subscription.toJSON();
{
  endpoint: "https://android.googleapis.com/gcm/send/a-subscription-id",
  keys: {
    auth: 'AEl35...7fG',
    p256dh: 'Fg5t8...2rC'
  }
}
```

Imagine a Ruby app endpoint that responds to the request by triggering notification through the `webpush` gem. VAPID details include a URL or mailto address for our website and the Base64-encoded public/private VAPID key pair we generated earlier.

```ruby
# app.rb
post '/push' do
  Webpush.payload_send(
    message: params[:message]
    endpoint: params[:subscription][:endpoint],
    p256dh: params[:subscription][:keys][:p256dh],
    auth: params[:subscription][:keys][:auth],
    ttl: 24 * 60 * 60,
    vapid: {
      subject: 'mailto:sender@example.com',
      public_key: ENV['VAPID_PUBLIC_KEY'],
      private_key: ENV['VAPID_PRIVATE_KEY']
    }
  )
end
```

In Node.js, usage of the `web-push` package might look like this:

```javascript
# index.js
const webpush = require('web-push');

// ...

app.post('/push', function(request, response) {
  const subscription = request.param('subscription');
  const message = request.param('message');

  setTimeout(() => {
    const options = {
      TTL: 24 * 60 * 60,
      vapidDetails: {
        subject: 'mailto:sender@example.com',
        publicKey: process.env.VAPID_PUBLIC_KEY,
        privateKey: process.env.VAPID_PRIVATE_KEY
      },
    }

    webpush.sendNotification(
      subscription,
      message,
      options
    );

  }, 0);

  response.send('OK');
});
```

## Receiving the push event

Your `/serviceworker.js` script can respond to `'push'` events to trigger desktop notifications by calling `showNotification` on the `registration` property.

```javascript
// serviceworker.js
// The serviceworker context can respond to 'push' events and trigger
// notifications on the registration property
self.addEventListener('push', (event) => {
  let title = (event.data && event.data.text()) || 'Yay a message';
  let body = 'We have received a push message';
  let tag = 'push-simple-demo-notification-tag';
  let icon = '/assets/my-logo-120x120.png';

  event.waitUntil(self.registration.showNotification(title, { body, icon, tag }));
});
```

Before the notifications can be displayed, the user must grant permission for [notifications](https://developer.mozilla.org/en-US/docs/Web/API/notification) in a browser prompt, using something like the example below.

```javascript
// application.js

// Let's check if the browser supports notifications
if (!('Notification' in window)) {
  console.error('This browser does not support desktop notification');
}

// Let's check whether notification permissions have already been granted
else if (Notification.permission === 'granted') {
  console.log('Permission to receive notifications has been granted');
}

// Otherwise, we need to ask the user for permission
else if (Notification.permission !== 'denied') {
  Notification.requestPermission(function (permission) {
    // If the user accepts, let's create a notification
    if (permission === 'granted') {
      console.log('Permission to receive notifications has been granted');
    }
  });
}
```

After all that setup, we should see a browser notification triggered via the Push API.

As this is still an emerging technology, things are rapidly changing. I'd be
interested to hear how things are working out for folks integrating web push
into their web apps.
