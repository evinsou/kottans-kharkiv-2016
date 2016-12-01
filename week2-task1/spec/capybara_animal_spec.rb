describe Capybara do
  let(:passed_12_years) { Timecop.travel(Date.today + 365 * 12 + 1) }
  subject!(:capybara) { described_class.new }

  it { is_expected.to be_an(Capybara) }

  its(:age) { is_expected.to eq(0) }
  its(:color) { is_expected.to eq('brown') }
  its(:hunger) { is_expected.to eq(0) }
  its(:fatigue) { is_expected.to eq(0) }

  it { is_expected.to respond_to(:walk) }
  it { is_expected.to respond_to(:eat) }
  it { is_expected.to respond_to(:sound) }
  it { is_expected.to respond_to(:swim) }
  it { is_expected.to respond_to(:sleep) }

  it { is_expected.to be_alive }

  context 'when a day passed' do
    it 'gets more aged' do
      expect { Timecop.travel(Date.today + 1) }.to change(capybara, :age)
    end
  end

  context 'when twelve years passed' do
    it 'died' do
      expect { passed_12_years }.to change(capybara, :alive?).to(false)
    end
  end

  context 'when it died' do
    before { passed_12_years }

    it 'can not walk' do
      expect { capybara.walk }.to raise_error
    end

    it 'can not eat' do
      expect { capybara.eat }.to raise_error
    end

    it 'can not sound' do
      expect { capybara.sound }.to raise_error
    end

    it 'can not swim' do
      expect { capybara.swim }.to raise_error
    end

    it 'can not sleep' do
      expect { capybara.sleep }.to raise_error
    end
  end

  it_behaves_like("reacting with", :fatigue,
      walk: 2,
      eat: 1,
      sound: 0.5,
      swim: 3 )

  it_behaves_like("reacting with", :hunger,
      walk: 1.5,
      sleep: 0.5,
      sound: 0.2,
      swim: 4 )

  context 'when a capybara is refreshed its state' do
    before { capybara.walk }

    it_should_behave_like("refreshed of", :fatigue, by: :sleep)
    it_should_behave_like("refreshed of", :hunger, by: :eat)
  end
end
