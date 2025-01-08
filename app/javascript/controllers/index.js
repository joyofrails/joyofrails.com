// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from './application';

import ClipboardCopy from './clipboard-copy';
import CurrentPage from './current-page';
import Darkmode from './darkmode';
import Flash from './flash';
import ModalOpener from './modal-opener';

import Dialog from './dialog';

import PwaInstallation from './pwa/installation';
import PwaWebPushSubscription from './pwa/web-push-subscription';
import PwaWebPushDemo from './pwa/web-push-demo';

import AnalyticsCustomEvent from './analytics/custom-event';
import TableOfContents from './table-of-contents';

import FrameForm from './forms/frame';
import AutosubmitForm from './forms/autosubmit';
import SelectNav from './forms/select-nav';
import SyntaxHighlightPreview from './syntax-highlight/preview';

import SnippetPreview from './snippets/preview';
import SnippetEditor from './snippets/editor';
import SnippetScreenshot from './snippets/screenshot';
import SnippetTweet from './snippets/tweet';

import SearchCombobox from './searches/combobox';
import SearchListbox from './searches/listbox';

import RubyEnumerationDemo from './demos/ruby-enumeration';

application.register('clipboard-copy', ClipboardCopy);
application.register('current-page', CurrentPage);
application.register('darkmode', Darkmode);
application.register('flash', Flash);
application.register('modal-opener', ModalOpener);

application.register('dialog', Dialog);

application.register('pwa-installation', PwaInstallation);
application.register('pwa-web-push-subscription', PwaWebPushSubscription);
application.register('pwa-web-push-demo', PwaWebPushDemo);

application.register('analytics', AnalyticsCustomEvent);
application.register('table-of-contents', TableOfContents);

application.register('frame-form', FrameForm);
application.register('autosubmit-form', AutosubmitForm);
application.register('select-nav', SelectNav);
application.register('syntax-highlight-preview', SyntaxHighlightPreview);

application.register('snippet-preview', SnippetPreview);
application.register('snippet-editor', SnippetEditor);
application.register('snippet-screenshot', SnippetScreenshot);
application.register('snippet-tweet', SnippetTweet);

application.register('search-combobox', SearchCombobox);
application.register('search-listbox', SearchListbox);

application.register('demo-ruby-enumeration', RubyEnumerationDemo);
