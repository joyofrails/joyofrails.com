import consumer from './consumer';
import { debug } from '../utils';

const console = debug('app:javascript:channels:heartbeat-channel');

export const subscribe = () => {
  consumer.subscriptions.create('HeartbeatChannel', {
    received(data) {
      console.log('received', data);
      new Notification(data['title'], { body: data['body'] });
    },
  });
};
