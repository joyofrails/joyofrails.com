// This helper file provides a consistent API for testing Stimulus Controllers
//
// Use:
// import { screen, userEvent, render, startStimulus } from './stimulusHelper';
// import MyController from './my_controller';
//
// const user = userEvent.setup();
//
// beforeEach(() => startStimulus('my', MyController));
//
// it('should do something', async () => {
//   await render(`<button data-controller="my" data-action="my#action">click</button>`);
//
//   const button = await screen.findByRole('button');
//   await user.click(button);
//
//   expect(await screen.findByRole('heading')).toHaveTextContent('something');
// });

import { Application } from '@hotwired/stimulus';

class TestApplication extends Application {
  handleError(error, _message, _detail) {
    throw error;
  }
}

let application;

// Initializes and registers the controller for the test file
// Use it in a before block:
// beforeEach(() => startStimulus('dom', DomController));
//
// @name = string of the controller
// @controller = controller class
//
// https://stimulus.hotwired.dev/handbook/installing#using-other-build-systems
export function startStimulus(name, controller) {
  if (!application) {
    application = new TestApplication(document.body);
    application.start();
  }
  application.register(name, controller);
}

// Private
// Stop the global application and remove it from memory after each test
//
// Remove any elements added to the DOM
afterEach(function cleanup() {
  if (application) {
    application.stop();
    application = null;
  }
  document.body.innerHTML = '';
});

// Renders HTML of the given container using appendChild
// - It trims content to prevent false negatives
// - It's async so there's time for the Stimulus controller to load
//
// Use within tests:
// await render(`<p>My HTML Content</p>`);
export async function render(content = '', baseElement = document.body) {
  const container = baseElement.appendChild(document.createElement('div'));
  container.innerHTML = content.trim();
  return new Promise((resolve) => window.requestAnimationFrame(resolve));
}

export * from '@testing-library/dom';
export { default as userEvent } from '@testing-library/user-event';
export { vi, expect, describe, it, beforeEach, afterEach } from 'vitest';
