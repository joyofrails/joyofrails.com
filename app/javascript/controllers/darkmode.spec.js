import { render, startStimulus, screen, userEvent } from '../jest/utils';
import Darkmode from './darkmode';

const user = userEvent.setup();

const html = `
<div data-controller="darkmode" class="flex items-center justify-between">
  <h2 data-darkmode-target="description" data-action="click->darkmode#toggle" class="hidden mr-3 sm:block cursor-pointer">Light Mode</h2>
  <button data-action="click->darkmode#toggle" id="theme-toggle" type="button" class="text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5" aria-label="Toggle Dark Mode" role="button">
    <svg aria-role="graphics-symbol" data-darkmode-target="darkIcon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
    <svg aria-role="graphics-symbol" data-darkmode-target="lightIcon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
    <svg aria-role="graphics-symbol" data-darkmode-target="systemIcon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"> <g> <path d="m675 1012.5c-9.9453 0-19.484 3.9492-26.516 10.984-7.0352 7.0312-10.984 16.57-10.984 26.516v37.5c0 13.398 7.1484 25.777 18.75 32.477 11.602 6.6992 25.898 6.6992 37.5 0 11.602-6.6992 18.75-19.078 18.75-32.477v-37.5c0-9.9453-3.9492-19.484-10.984-26.516-7.0312-7.0352-16.57-10.984-26.516-10.984z" /> <path d="m330.38 891.75-26.625 26.625c-7.9375 6.7969-12.676 16.594-13.078 27.035-0.40625 10.441 3.5664 20.578 10.953 27.965s17.523 11.359 27.965 10.953c10.441-0.40234 20.238-5.1406 27.035-13.078l26.625-26.625c8.2656-9.6523 11.082-22.84 7.4766-35.027-3.6016-12.188-13.137-21.723-25.324-25.324-12.188-3.6055-25.375-0.78906-35.027 7.4766z" /> <path d="m225 562.5h-37.5c-13.398 0-25.777 7.1484-32.477 18.75-6.6992 11.602-6.6992 25.898 0 37.5 6.6992 11.602 19.078 18.75 32.477 18.75h37.5c13.398 0 25.777-7.1484 32.477-18.75 6.6992-11.602 6.6992-25.898 0-37.5-6.6992-11.602-19.078-18.75-32.477-18.75z" /> <path d="m330.38 308.25c9.6523 8.2656 22.84 11.082 35.027 7.4766 12.188-3.6016 21.723-13.137 25.324-25.324 3.6055-12.188 0.78906-25.375-7.4766-35.027l-26.625-26.625c-9.6523-8.2656-22.84-11.082-35.027-7.4766-12.188 3.6016-21.723 13.137-25.324 25.324-3.6055 12.188-0.78906 25.375 7.4766 35.027z" /> <path d="m675 187.5c9.9453 0 19.484-3.9492 26.516-10.984 7.0352-7.0312 10.984-16.57 10.984-26.516v-37.5c0-13.398-7.1484-25.777-18.75-32.477-11.602-6.6992-25.898-6.6992-37.5 0-11.602 6.6992-18.75 19.078-18.75 32.477v37.5c0 9.9453 3.9492 19.484 10.984 26.516 7.0312 7.0352 16.57 10.984 26.516 10.984z" /> <path d="m856.88 315.75c-63.141-40.391-137.93-58.617-212.57-51.797-74.645 6.8164-144.9 38.289-199.68 89.453s-90.965 119.11-102.85 193.11c-11.891 74.004 1.1953 149.86 37.191 215.61s92.852 117.64 161.61 147.5c68.754 29.855 145.49 35.973 218.11 17.391 72.613-18.582 136.98-60.812 182.94-120.02 45.957-59.211 70.898-132.04 70.887-206.99 0.19922-56.672-13.969-112.47-41.188-162.18-27.215-49.707-66.586-91.707-114.44-122.07zm-444.38 284.25c-0.015625-63.133 22.723-124.16 64.047-171.89 41.324-47.73 98.469-78.969 160.95-87.988v519.75c-62.484-9.0195-119.63-40.258-160.95-87.988-41.324-47.727-64.062-108.75-64.047-171.89z" /> </g> </svg>
  </button>
</div>
`;

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
