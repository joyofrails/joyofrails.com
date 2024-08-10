import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:forms:frame');

// This controller is used to handle form submissions that should redirect out
// of a Turbo Frame.
export default class extends Controller {
  static targets = ['refreshButton'];
  static values = {
    redirectFrame: String,
  };

  connect() {
    console.log('Connect!');
    this.refreshButtonTarget.hidden = true;
  }

  refresh() {
    console.log('Refresh!');
    this.refreshButtonTarget.click();
  }

  redirect(event) {
    if (this.refreshButtonTarget === event.detail.formSubmission.submitter)
      return;

    if (event.detail.success) {
      const fetchResponse = event.detail.fetchResponse;
      history.pushState(
        { turbo_frame_history: true },
        '',
        fetchResponse.response.url,
      );
      console.log('Redirect!', fetchResponse.response.url, {
        frame: this.redirectFrameValue,
      });
      Turbo.visit(fetchResponse.response.url, {
        frame: this.redirectFrameValue,
      });
    }
  }
}
