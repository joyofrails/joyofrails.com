import {
  describe,
  it,
  expect,
  render,
  startStimulus,
  screen,
  userEvent,
  beforeEach,
} from '../../test/utils';

import SearchCombobox from './combobox';

import html from '../../test/fixtures/views/searches/combobox.html?raw';

describe('Combobox', () => {
  beforeEach(() => {
    startStimulus('search-combobox', SearchCombobox);
  });

  it('should open the combobox', async () => {
    const user = userEvent.setup();

    await render(html);

    const combobox = await screen.findByRole('combobox');
    const listbox = await screen.findByRole('listbox');

    expect(combobox).toHaveAttribute('aria-expanded');

    user.click(combobox);

    expect(combobox).toHaveAttribute('aria-expanded', 'true');
    expect(listbox).not.toHaveClass('hidden');
    expect(listbox).toBeVisible();
  });

  it('should close the combobox', async () => {
    const user = userEvent.setup();

    await render(html);

    const combobox = await screen.findByRole('combobox');
    const listbox = await screen.findByRole('listbox');

    await user.click(combobox);
    await user.keyboard('[Escape]');

    expect(combobox).toHaveAttribute('aria-expanded', 'false');
    expect(listbox).toHaveClass('hidden');
  });

  it('should select option', async () => {
    const user = userEvent.setup();

    await render(html);

    const combobox = await screen.findByRole('combobox');

    const option = await screen.findByRole('option', {
      name: 'Introducing Joy of Rails',
    });

    await user.click(combobox);

    // Select second option
    await user.keyboard('[ArrowDown]');
    await user.keyboard('[ArrowDown]');

    expect(combobox).toHaveAttribute('aria-expanded', 'true');
    expect(combobox).toHaveAttribute('aria-activedescendant', option.id);

    expect(option).toHaveClass('selected');
    expect(option).toHaveAttribute('aria-selected', 'true');
  });
});
