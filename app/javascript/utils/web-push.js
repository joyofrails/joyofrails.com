const webPushKey = window.config.webPushKey;

export const withPermission = async () => {
  let permission = Notification.permission;
  if (permission === 'granted') {
    return permission;
  } else if (permission === 'denied') {
    throw new Error(
      `Permission for notifications is ${permission}. Please change your browser settings if you wish to support web push.`,
    );
  } else {
    permission = await Notification.requestPermission();

    if (permission === 'granted') {
      return permission;
    } else {
      throw new Error(
        `Permission for notifications is ${permission}. Please change your browser settings if you wish to support web push.`,
      );
    }
  }
};

export const subscribe = async () => {
  if (!navigator.serviceWorker) {
    throw new Error('Service worker not supported');
  }

  // When serviceWorker is supported, installed, and activated,
  // subscribe the pushManager property with the webPushKey
  const registration = await navigator.serviceWorker.ready;

  let subscription = await getSubscription();

  if (!subscription) {
    subscription = registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: webPushKey,
    });

    if (!subscription) {
      throw new Error('Web push subscription failed');
    }
  }

  return subscription;
};

export const unsubscribe = async () => {
  const subscription = await getSubscription();

  if (subscription) {
    // Unsubscribe if we have an existing subscription
    return await subscription.unsubscribe();
  } else {
    return false;
  }
};

export const getSubscription = async () => {
  const registration = await navigator.serviceWorker.ready;

  return await registration.pushManager.getSubscription();
};
