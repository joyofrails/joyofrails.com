require "rails_helper"

RSpec.describe Examples::AppFile, type: :model do
  describe "with path" do
    subject { described_class.from("config/database.yml") }

    it { expect(subject.app_path).to eq("config/database.yml") }

    it { expect(subject.read).to be =~ %r{adapter: sqlite3} }
    it { expect(subject.readlines).to include(%r{adapter: sqlite3}) }
    it { expect(subject.readlines.count).to be > 20 }

    it { expect(subject.basename).to eq("database.yml") }

    it { expect(subject.extname).to eq(".yml") }

    it { expect(subject.repo_url).to eq("https://github.com/joyofrails/joyofrails.com/blob/HEAD/config/database.yml") }
  end

  describe "with path from revision" do
    subject { described_class.from("config/database.yml", revision: "bfe2f6a1fa") }

    it { expect(subject.app_path).to eq("config/database.yml") }

    it { expect(subject.read).to be =~ %r{adapter: litedb} }
    it { expect(subject.readlines).to include(%r{adapter: litedb}) }
    it { expect(subject.readlines.count).to be > 20 }

    it { expect(subject.basename).to eq("database.yml") }

    it { expect(subject.extname).to eq(".yml") }

    it { expect(subject.repo_url).to eq("https://github.com/joyofrails/joyofrails.com/blob/bfe2f6a1fa/config/database.yml") }
  end
end
