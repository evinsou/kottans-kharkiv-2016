shared_examples_for "a changeable field" do |action, field, value|
  it "returns #{value} from ##{action}" do
    expect { capybara.send(action) }.to change(capybara, field).by(value)
  end
end

shared_examples_for "reacting with" do |field, action_value_hash|
  action_value_hash.each_pair do |action, value|
    it_should_behave_like("a changeable field", action, field, value)
  end
end

shared_examples_for "refreshed of" do |field, action_hash|
  it "becomes refreshed from #{field} by ##{action_hash[:by]}" do
    expect { capybara.send(action_hash[:by]) }.to change(capybara, field).to(0)
  end
end
