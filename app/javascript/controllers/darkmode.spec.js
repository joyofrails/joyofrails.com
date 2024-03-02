import {
  describe,
  it,
  expect,
  render,
  startStimulus,
  screen,
  userEvent,
} from '../test/utils';
import Darkmode from './darkmode';

import html from '../test/fixtures/views/darkmode/switch.html?raw';

const user = userEvent.setup();

describe('Darkmode', () => {
  beforeEach(() => {
    startStimulus('darkmode', Darkmode);
  });

  afterEach(() => {
    document.documentElement.classList.remove('light');
    document.documentElement.classList.remove('dark');
    localStorage.removeItem('color-theme');
  });

  it('should initialize in system mode', async () => {
    await render(html);

    const heading = await screen.findByRole('heading');

    expect(heading).toHaveTextContent('System Mode');
    expect(document.documentElement).not.toHaveClass('dark');
    expect(document.documentElement).toHaveClass('light');
  });

  it('should initialize in dark mode', async () => {
    localStorage.setItem('color-theme', 'dark');

    await render(html);

    const heading = await screen.findByRole('heading');

    expect(heading).toHaveTextContent('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
  });

  it('should initialize in light mode', async () => {
    localStorage.setItem('color-theme', 'light');

    await render(html);

    const heading = await screen.findByRole('heading');

    expect(heading).toHaveTextContent('Light Mode');
    expect(document.documentElement).toHaveClass('light');
  });

  it('should set to dark mode', async () => {
    await render(html);

    const button = await screen.findByRole('button');
    await user.click(button);

    await screen.findByText('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
    expect(document.documentElement).not.toHaveClass('light');
  });

  it('should set to light mode', async () => {
    await render(html);

    const button = screen.getByRole('button');
    await user.click(button);

    await screen.findByText('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
    expect(document.documentElement).not.toHaveClass('light');

    await user.click(button);
    await screen.findByText('Light Mode');
    expect(document.documentElement).toHaveClass('light');
    expect(document.documentElement).not.toHaveClass('dark');
  });

  it('should cycle back to system mode', async () => {
    await render(html);

    const button = screen.getByRole('button');
    await user.click(button);

    await screen.findByText('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
    expect(document.documentElement).not.toHaveClass('light');

    await user.click(button);
    await screen.findByText('Light Mode');
    expect(document.documentElement).not.toHaveClass('dark');
    expect(document.documentElement).toHaveClass('light');

    await user.click(button);
    await screen.findByText('System Mode');
    expect(document.documentElement).not.toHaveClass('dark');
    expect(document.documentElement).toHaveClass('light');
  });
});
